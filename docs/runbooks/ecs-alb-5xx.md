# ECS Fargate Platform — Runbook

## Incident: ALB 5XX Errors

**Symptoms:** Users seeing 502/503/504 errors. ALB returning 5XX responses.

**Log Group:** `/ecs/dev/app`  
**Cluster:** `dev-ecs-fargate`  
**Service:** `dev-app-svc`  
**ALB:** `dev-alb-1239579835.us-east-1.elb.amazonaws.com`

---

### Step 1 — Check ECS Service Health

```bash
aws ecs describe-services \
  --cluster dev-ecs-fargate \
  --services dev-app-svc \
  --query "services[0].{Running:runningCount,Desired:desiredCount,Pending:pendingCount,Status:status}"
```

**Expected:** `Running` matches `Desired`.  
**If Running = 0:** Tasks are crashing — proceed to Step 2.

---

### Step 2 — Check Task Logs in CloudWatch

```bash
aws logs tail /ecs/dev/app --follow
```

Look for:
- Application errors or exceptions
- Secret injection failures (`ResourceNotFoundException`)
- Out of memory errors

---

### Step 3 — Check for Stopped Tasks and Exit Codes

```bash
aws ecs list-tasks \
  --cluster dev-ecs-fargate \
  --desired-status STOPPED \
  --query "taskArns"
```

Then describe the stopped task:

```bash
aws ecs describe-tasks \
  --cluster dev-ecs-fargate \
  --tasks <task-arn> \
  --query "tasks[0].containers[0].{Reason:reason,ExitCode:exitCode}"
```

**Exit code 1:** Application error — check logs.  
**Exit code 137:** OOM kill — increase task memory in `task_definition.tf`.

---

### Step 4 — Validate Target Group Health

```bash
aws elbv2 describe-target-health \
  --target-group-arn arn:aws:elasticloadbalancing:us-east-1:376129869231:targetgroup/dev-tg/c3519910b2242ff3
```

**Expected:** `State: healthy`  
**If unhealthy:** Tasks are running but failing health checks — check the health check path in `modules/alb/main.tf`.

---

### Step 5 — Force Restart the Service

If logs show no errors but tasks are stuck:

```bash
aws ecs update-service \
  --cluster dev-ecs-fargate \
  --service dev-app-svc \
  --force-new-deployment
```

Monitor recovery:

```bash
aws ecs wait services-stable \
  --cluster dev-ecs-fargate \
  --services dev-app-svc
```

---

### Step 6 — Verify Secrets Manager Access

If containers fail to start with secrets errors:

```bash
aws secretsmanager get-secret-value \
  --secret-id dev/app/secrets \
  --query "SecretString"
```

Confirm the IAM execution role has `secretsmanager:GetSecretValue` on this secret ARN.

---

## Escalation

If all steps above pass and 5XX errors persist:
1. Check WAF rules — a WAF block returns 403/5XX to the client
2. Check ALB access logs in S3 bucket `dev-alb-logs-376129869231`
3. Review CloudWatch metrics for ALB: `HTTPCode_Target_5XX_Count`