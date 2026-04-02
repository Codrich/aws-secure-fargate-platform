# Secure AWS ECS Fargate Platform (Terraform + CI/CD + DevSecOps)
🔗 Cloud-Native | DevSecOps | Infrastructure as Code

[![AWS](https://img.shields.io/badge/AWS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)](https://aws.amazon.com)
[![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io)
[![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)](https://github.com/features/actions)

**Production-grade secure cloud-native platform** on AWS using **Terraform IaC**, **ECS Fargate**, and **DevSecOps practices**.

---

## 📌 Overview

This project implements a production-grade cloud-native platform for deploying a containerized Flask application. It combines a secure multi-AZ VPC foundation with ECS Fargate compute, ALB with WAF protection, GitHub Actions CI/CD (OIDC), and comprehensive observability — all managed as code with Terraform.

Built with a strong **security-first mindset**, following AWS Well-Architected Framework principles.

---

## 🔑 Key Features

- **Secure multi-AZ VPC** with public/private subnets, NAT Gateway, and remote state (S3 + DynamoDB locking)
- **Application Load Balancer (ALB)** with HTTPS (ACM) and **WAF** integration
- **Containerized Python Flask app** running on **Amazon ECS Fargate**
- **CI/CD Pipeline** using GitHub Actions + OIDC (no static credentials)
- **DevSecOps hardening**: least-privilege IAM roles, security groups, WAF, and GuardDuty-ready setup
- **Observability**: CloudWatch logs, metrics, alarms, and dashboards

---

## 🏗️ Architecture

![Architecture Diagram](docs/screenshots/architecture.png)

<p align="center"><strong>High-level architecture of the Secure AWS ECS Fargate Platform</strong></p>

### 🔍 Key Design Decisions
- Private subnets for ECS tasks and database to minimize attack surface
- ALB as the single secure entry point with HTTPS termination
- OIDC-based authentication for CI/CD to eliminate long-lived credentials
- Modular Terraform structure for reusability across environments (dev/staging/prod)
- Defense-in-depth using network segmentation, IAM, WAF, and KMS

---

## ⚙️ CI/CD Pipeline (GitHub Actions + OIDC)

**Pipeline Flow:**
1. Code pushed to GitHub → Workflow triggers
2. OIDC authenticates securely to AWS
3. Terraform `plan` / `apply`
4. Docker image built and pushed to Amazon ECR
5. ECS service updated with new task definition

**Why OIDC?**  
Eliminates hardcoded credentials and follows enterprise security best practices.

---

## 🔒 Security & DevSecOps

- **Implemented**: Least-privilege IAM roles, restrictive Security Groups, HTTPS enforcement, private subnets, WAF on ALB, private ECR
- **Ready for**: GuardDuty, VPC Flow Logs, infrastructure scanning (Checkov/tfsec)

---

## 📊 Observability

- CloudWatch Logs for ECS tasks and VPC Flow Logs
- CloudWatch Metrics (CPU, memory, ALB requests)
- CloudWatch Alarms for high CPU and 5xx errors

---

## 🚀 Quick Start

```bash
git clone https://github.com/Codrich/aws-secure-fargate-platform.git
cd aws-secure-fargate-platform


terraform init
terraform plan -var-file="environments/dev/terraform.tfvars"
terraform apply -var-file="environments/dev/terraform.tfvars"

```
## 📌 Key Takeaways

- Built a production-style cloud-native platform using AWS and Terraform  
- Implemented secure CI/CD using GitHub Actions with OIDC (no static credentials)  
- Applied DevSecOps principles with IAM least privilege, WAF, and network isolation  
- Designed for scalability, security, and observability following AWS best practices  

---

## 📌 Status

🚧 In active development — CI/CD functional, WAF integrated, and continuous improvements ongoing.
