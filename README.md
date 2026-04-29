# AWS Secure ECS Fargate Platform

🔗 Cloud-Native | DevSecOps | Infrastructure as Code

Production-grade cloud infrastructure platform on AWS built with Terraform and modern DevOps practices. Demonstrates secure, scalable, and observable deployment of containerized applications using Amazon ECS Fargate.

[![AWS](https://img.shields.io/badge/AWS-FF9900?style=for-the-badge\&logo=amazonaws\&logoColor=white)](https://aws.amazon.com)
[![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge\&logo=terraform\&logoColor=white)](https://www.terraform.io)
[![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge\&logo=github-actions\&logoColor=white)](https://github.com/features/actions)

---

## 📌 Overview

This project implements a production-style container platform on AWS using Infrastructure as Code (Terraform), emphasizing security, automation, and operational readiness. It provisions a secure, multi-tier architecture where a containerized application is deployed on ECS Fargate behind an Application Load Balancer (ALB) with HTTPS and WAF protection.

The platform is designed with a **security-first and operations-focused mindset**, emphasizing real-world practices such as secrets management, CI/CD automation, observability, and incident response.

---

## 🚀 Core Features

* Infrastructure as Code with **Terraform (modular design)**
* **Amazon ECS Fargate** for serverless container orchestration
* **Application Load Balancer (ALB)** with HTTPS (ACM) and WAF integration
* **CI/CD pipeline** using GitHub Actions with OIDC authentication (no static credentials)
* **Secrets management** using AWS Secrets Manager with runtime injection
* **Observability** using Amazon CloudWatch (logs, metrics, alarms)
* **Autoscaling** based on CPU utilization
* **Operational runbooks** for incident response

---

## 🏗 Architecture

![Architecture Diagram](docs/screenshots/architecture.png)

<p align="center"><strong>High-level architecture of the ECS Fargate platform</strong></p>

### Key Design Decisions

* ECS tasks run in **private subnets** to minimize exposure
* ALB serves as the **single secure entry point** with HTTPS termination
* CI/CD uses **OIDC authentication** to eliminate long-lived credentials
* Terraform is structured into **modular components** for reuse across environments
* Security is enforced using **defense-in-depth** (IAM, security groups, WAF, network isolation)

---

## ⚙️ CI/CD Pipeline

Pipeline implemented using GitHub Actions and OpenID Connect (OIDC):

1. Code push triggers workflow
2. OIDC securely authenticates to AWS
3. Terraform `plan` and `apply` executed
4. Docker image built and pushed to Amazon ECR
5. ECS service updated with new task definition

### Why OIDC?

OIDC eliminates the need for static AWS credentials in CI/CD, aligning with enterprise security best practices.

---

## 🔒 Security & DevSecOps

* **Implemented**: Least-privilege IAM roles, restrictive Security Groups, HTTPS enforcement, private subnets, WAF on ALB, private ECR
* **Secrets Management**: AWS Secrets Manager with IAM-based access controls — secrets injected into ECS tasks at startup, zero hardcoded credentials in source control
* **Ready for**: GuardDuty, VPC Flow Logs, infrastructure scanning (Checkov/tfsec)

---

## 📊 Observability

* CloudWatch Logs for ECS task logging
* CloudWatch Metrics for CPU, memory, and ALB traffic
* CloudWatch Alarms for:

  * High CPU utilization
  * ALB 5xx error rates
* Centralized logging for debugging and monitoring

---

## 🛠️ Operations & Reliability

* Implemented ALB 5XX incident runbook covering ECS health checks, CloudWatch log analysis, target group validation, and forced redeployment
* Centralized secrets management using AWS Secrets Manager with least-privilege IAM injection
* CloudWatch logging enabled for all ECS tasks with structured log groups per environment

### 📘 Runbooks

* [ALB 5XX Incident Runbook](docs/runbooks/ecs-alb-5xx.md)

---

## 🚀 Quick Start

```bash
git clone https://github.com/Codrich/aws-secure-fargate-platform.git
cd aws-secure-fargate-platform

terraform init
terraform plan -var-file="environments/dev/terraform.tfvars"
terraform apply -var-file="environments/dev/terraform.tfvars"
```

---

## 🧠 Engineering Highlights

* Designed a **modular Terraform architecture** for reusable AWS infrastructure
* Built a **secure ECS Fargate platform** with ALB, WAF, and private networking
* Implemented **CI/CD pipelines using GitHub Actions with OIDC authentication**
* Integrated **AWS Secrets Manager** for secure runtime secret injection
* Troubleshot and resolved **remote state and infrastructure dependency issues**
* Developed **operational runbooks** for production incident response

---

## 📌 Status

Actively maintained and enhanced with ongoing improvements in security, observability, and platform engineering practices.
