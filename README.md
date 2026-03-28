# 🚀 Secure AWS ECS Fargate Platform

**Terraform + CI/CD + DevSecOps + Observability**

---

## 📌 Overview

This project demonstrates a **production-style cloud platform** designed to deploy and operate containerized applications securely and at scale on AWS.

It simulates a real-world environment where:

* Infrastructure is fully defined using **Terraform (IaC)**
* Applications are deployed via **automated CI/CD pipelines**
* Security is enforced using **DevSecOps best practices**
* Systems are monitored using **observability tooling**

---

## 🎯 Why This Project Matters

Modern cloud engineering is not just about deploying apps — it's about:

* Building **secure and scalable infrastructure**
* Automating deployments with **CI/CD**
* Implementing **least privilege access**
* Ensuring **visibility and reliability in production**

This project reflects how real companies deploy services in AWS.

---

## 🏗️ Architecture Diagram

![Architecture](docs/architecture.png)

---

## 🧠 Architecture Deep Dive

### 🌐 Networking

* Custom **VPC** with public and private subnets
* **Public Subnet** → Application Load Balancer (ALB)
* **Private Subnet** → ECS Fargate tasks (no direct internet exposure)

### ⚖️ Load Balancing

* **Application Load Balancer (ALB)**

  * HTTP → HTTPS redirect
  * TLS termination
  * Routes traffic to ECS service

### 🐳 Compute Layer

* **ECS Fargate**

  * Serverless container orchestration
  * Runs Flask app in isolated tasks
  * Auto-integrated with ALB target group

### 📦 Container Registry

* **Amazon ECR**

  * Stores Docker images
  * Version-controlled deployments

### 🌍 DNS

* **Route 53**

  * Custom domain routing
  * Points to ALB

---

## ⚙️ Tech Stack

| Category      | Tools                                |
| ------------- | ------------------------------------ |
| Cloud         | AWS                                  |
| IaC           | Terraform                            |
| Containers    | Docker, ECR                          |
| Orchestration | ECS Fargate                          |
| CI/CD         | GitHub Actions, AWS CodePipeline     |
| Security      | IAM, Security Groups, WAF, GuardDuty |
| Monitoring    | CloudWatch                           |

---

## 🔄 CI/CD Pipeline (End-to-End)

1. Developer pushes code to GitHub
2. GitHub Actions:

   * Builds Docker image
   * Runs checks (optional lint/test)
3. Image pushed to Amazon ECR
4. ECS service pulls latest image
5. New task revision deployed automatically

👉 Result: **Fully automated deployments (zero manual steps)**

---

## 🔐 Security (DevSecOps)

### Identity & Access

* IAM roles with **least privilege access**
* No hardcoded credentials (AWS best practices)

### Network Security

* Security Groups restrict:

  * ALB → public traffic (443 only)
  * ECS → only from ALB

### Edge Protection

* HTTPS enforced via ALB
* (Optional) AWS WAF for Layer 7 protection

### Threat Detection

* (Optional) GuardDuty enabled for anomaly detection

---

## 📊 Observability

* **CloudWatch Logs**

  * Application logs
  * ECS task logs

* **CloudWatch Metrics**

  * CPU / Memory utilization
  * ALB request metrics

* **CloudWatch Alarms**

  * High CPU usage
  * Service health issues

👉 Enables real-time monitoring and alerting

---

## 🚀 Deployment

### 1. Clone Repository

```bash
git clone https://github.com/Codrich/aws-secure-vpc-terraform.git
cd aws-secure-vpc-terraform
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Deploy Infrastructure

```bash
terraform apply -var-file=environments/dev/terraform.tfvars
```

---

## 🧪 Application

Flask app running in ECS Fargate:

```python
app.run(host="0.0.0.0", port=80)
```

Accessible via:

* ALB DNS
* Custom domain (Route 53)

---

## 🧯 Troubleshooting

### ❌ ECS Task Not Starting

* Check CloudWatch Logs
* Verify IAM permissions
* Confirm container port mapping

### ❌ ALB Not Routing Traffic

* Check target group health
* Verify security groups
* Confirm HTTPS listener

### ❌ Terraform Errors

```bash
terraform init -reconfigure
terraform validate
terraform plan
```

---

## 📈 Future Improvements

* GitOps (ArgoCD / Flux)
* Multi-environment (dev/stage/prod)
* Blue/Green deployments
* Prometheus + Grafana
* Auto Scaling policies

---

## 🧠 Key Learnings

* Designing secure AWS architectures
* Implementing CI/CD pipelines
* Observability in distributed systems
* Infrastructure as Code best practices

---

## ⭐ Author

**Rich**
Cloud / DevSecOps Engineer

---
