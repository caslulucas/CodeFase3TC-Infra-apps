# Tech Challenge Fase 3 – Infraestrutura, Aplicações e DevSecOps

## Sobre o Projeto


---

## Objetivos


---

## Estrutura do Repositório

```text
.
├── .github/workflows
│   ├── analytics-ci.yaml
│   ├── auth-ci.yaml
│   ├── evaluation-ci.yaml
│   ├── flag-ci.yaml
│   ├── targeting-ci.yaml
│   └── terraform-ci.yaml
│
├── 01-terraform
│   ├── bootstrap
│   ├── environments
│   └── modules
│       ├── vpc
│       ├── eks
│       ├── rds
│       ├── redis
│       ├── dynamodb
│       ├── sqs
│       └── ecr
│
├── 02-services
│   ├── auth-service
│   ├── flag-service
│   ├── targeting-service
│   ├── evaluation-service
│   └── analytics-service
│
└── 03-docs
    ├── architecture.png
    ├── cicd-flow.png
    ├── cost-estimate.png
    └── report.md