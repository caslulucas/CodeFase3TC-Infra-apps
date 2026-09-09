# 🚀 Tech Challenge — Fase 3

## ToggleMaster Platform

Projeto desenvolvido para o Tech Challenge da Pós-Tech FIAP com foco na automação da infraestrutura e do ciclo de vida de uma plataforma baseada em microsserviços.

A solução aplica os conceitos de:

- Infrastructure as Code — IaC;
- Integração Contínua — CI;
- DevSecOps;
- Containers;
- Kubernetes;
- GitOps;
- Entrega Contínua — CD;
- Cloud Native Architecture.

> **Status atual:** o código Terraform, os workflows DevSecOps, os Dockerfiles e os manifestos GitOps estão implementados e validados. A infraestrutura AWS será provisionada e demonstrada na etapa prática utilizando o ambiente AWS Academy.

---

# 📖 Contexto do desafio

A empresa fictícia DevOps Solutions Inc. possuía uma arquitetura de microsserviços funcional, porém com diversos problemas operacionais:

- Deploys executados manualmente com `kubectl apply`;
- Conflitos entre versões implantadas por diferentes desenvolvedores;
- Credenciais tratadas de forma insegura;
- Vulnerabilidades não identificadas antes do deploy;
- Ambientes criados manualmente pelo console da AWS;
- Ausência de uma fonte central representando o estado do cluster;
- Baixa rastreabilidade das alterações.

O princípio adotado para solucionar esses problemas foi:

> **Se não está no código, não existe.**

A infraestrutura, os pipelines, os controles de segurança e os deployments passam a ser definidos, revisados e versionados como código.

---

# 🎯 Objetivos do projeto

- Provisionar a infraestrutura AWS por meio de Terraform;
- Utilizar módulos reutilizáveis para organizar o código de infraestrutura;
- Armazenar o estado do Terraform remotamente no Amazon S3;
- Criar workflows independentes para os cinco microsserviços;
- Executar testes e validações de qualidade;
- Adicionar SAST, SCA, Container Scan e Secret Scanning;
- Bloquear o pipeline quando vulnerabilidades críticas forem encontradas;
- Construir e publicar imagens Docker no Amazon ECR;
- Identificar as imagens utilizando o hash do commit;
- Atualizar automaticamente o repositório GitOps;
- Utilizar o ArgoCD para sincronizar os manifests com o Amazon EKS;
- Eliminar o deploy imperativo realizado diretamente pelo pipeline.

---

# 🏗️ Arquitetura da solução

```text
Desenvolvedor
      │
      ▼
GitHub — Código das aplicações e infraestrutura
      │
      ▼
GitHub Actions
      │
      ├── Build
      ├── Testes unitários
      ├── Lint
      ├── Análise estática
      ├── SAST
      ├── SCA
      ├── Secret Scan
      ├── Docker Build
      └── Container Scan
      │
      ▼
Amazon ECR
      │
      ▼
Atualização do deployment.yaml
      │
      ▼
Repositório GitOps
      │
      ▼
ArgoCD
      │
      ▼
Amazon EKS
      │
      ▼
Microsserviços ToggleMaster
```

## Separação de responsabilidades

```text
Repositório Infra-apps
├── Terraform;
├── Código dos microsserviços;
├── Dockerfiles;
└── GitHub Actions.

Repositório GitOps
├── Deployments;
├── Services;
├── Namespaces;
├── Kustomizations;
└── Applications do ArgoCD.
```

O pipeline de CI não executa `kubectl apply`.

O pipeline publica a imagem e altera o estado desejado no Git. O ArgoCD é responsável por reconciliar esse estado com o cluster Kubernetes.

---

# 🧩 Microsserviços

| Serviço | Linguagem | Porta | Responsabilidade |
|---|---:|---:|---|
| Auth | Go | 8001 | Autenticação e gerenciamento de chaves |
| Flag | Python | 8002 | Gerenciamento de feature flags |
| Targeting | Python | 8003 | Regras de segmentação |
| Evaluation | Go | 8004 | Avaliação de flags e regras |
| Analytics | Python | 8005 | Eventos, métricas e auditoria |

Cada microsserviço possui:

- Código-fonte próprio;
- Dockerfile próprio;
- Workflow próprio;
- Imagem própria;
- Repositório ECR próprio;
- Deployment Kubernetes próprio;
- Service Kubernetes próprio;
- Namespace próprio;
- Application própria no ArgoCD.

---

# 📂 Estrutura do repositório Infra-apps

```text
CodeFase3TC-Infra-apps
│
├── .github
│   └── workflows
│       ├── analytics-ci.yaml
│       ├── auth-ci.yaml
│       ├── evaluation-ci.yaml
│       ├── flag-ci.yaml
│       ├── targeting-ci.yaml
│       ├── terraform-ci.yaml
│       └── secrets-scan.yaml
│
├── 01-terraform
│   ├── bootstrap
│   ├── environments
│   │   ├── academy
│   │   └── personal
│   ├── modules
│   │   ├── vpc
│   │   ├── eks
│   │   ├── ecr
│   │   ├── rds
│   │   ├── redis
│   │   ├── dynamodb
│   │   └── sqs
│   ├── backend.tf
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
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
```

---

# 📂 Estrutura do repositório GitOps

```text
CodeFase3TC-GitOps
│
├── .github
│   └── workflows
│       └── validate-manifests.yaml
│
├── apps
│   ├── auth
│   ├── flag
│   ├── targeting
│   ├── evaluation
│   └── analytics
│
├── argocd
│   ├── root-app.yaml
│   ├── platform-app.yaml
│   ├── auth-app.yaml
│   ├── flag-app.yaml
│   ├── targeting-app.yaml
│   ├── evaluation-app.yaml
│   └── analytics-app.yaml
│
├── platform
│   ├── namespaces.yaml
│   ├── ingress.yaml
│   ├── secrets.example.yaml
│   └── kustomization.yaml
│
├── .editorconfig
├── .pre-commit-config.yaml
├── .trivyignore
├── Makefile
├── README.md
└── SECURITY.md
```

---

# ☁️ Infraestrutura AWS modelada

## Networking

- Amazon VPC;
- Duas zonas de disponibilidade;
- Subnets públicas;
- Subnets privadas;
- Internet Gateway;
- Route Tables;
- NAT Gateway opcional por ambiente.

## Kubernetes

- Amazon EKS;
- Managed Node Groups;
- Namespaces separados por microsserviço;
- ArgoCD para GitOps.

## Bancos de dados e cache

- Três bancos Amazon RDS PostgreSQL;
- Amazon ElastiCache Redis;
- Amazon DynamoDB `ToggleMasterAnalytics`.

## Mensageria

- Amazon SQS.

## Containers

- Cinco repositórios Amazon ECR:
  - `togglemaster-auth`;
  - `togglemaster-flag`;
  - `togglemaster-targeting`;
  - `togglemaster-evaluation`;
  - `togglemaster-analytics`.

## Estado Terraform

- Bucket Amazon S3 para backend remoto;
- Lock do state utilizando `use_lockfile`;
- O arquivo `terraform.tfstate` não permanece apenas na máquina local.

---

# 🎓 Compatibilidade com AWS Academy

No ambiente AWS Academy:

- O Terraform não cria Roles ou Policies IAM;
- A LabRole disponibilizada pelo laboratório é utilizada pelo EKS e pelos Node Groups;
- As credenciais da sessão são temporárias;
- Os recursos opcionais podem ser controlados por variáveis para reduzir consumo;
- O NAT Gateway pode ser desabilitado durante a demonstração acadêmica.

Para uma conta pessoal, o projeto está preparado para permitir uma arquitetura mais completa e a criação das Roles necessárias.

---

# 🧱 Infrastructure as Code

O Terraform foi dividido em módulos para separar responsabilidades e reduzir duplicação.

```text
main.tf
  │
  ├── módulo VPC
  ├── módulo EKS
  ├── módulo ECR
  ├── módulo DynamoDB
  ├── módulo SQS
  ├── módulo RDS — Auth
  ├── módulo RDS — Flag
  ├── módulo RDS — Targeting
  └── módulo Redis
```

## Benefícios

- Infraestrutura reproduzível;
- Versionamento das alterações;
- Revisão por Pull Request;
- Padronização;
- Menor dependência do console;
- Menor risco de configuração manual divergente;
- Possibilidade de recriação do ambiente.

---

# 💾 Backend remoto Terraform

O bootstrap cria o bucket S3 utilizado pelo projeto principal.

```text
Terraform
    │
    ▼
terraform.tfstate
    │
    ▼
Amazon S3
```

O state é necessário para que o Terraform saiba quais recursos estão sob gerenciamento e relacione os recursos declarados com os recursos existentes na AWS.

O lock evita que duas execuções tentem alterar o mesmo state simultaneamente.

---

# 🔐 DevSecOps

A segurança foi incorporada antes da publicação e do deploy.

## Workflows

Os cinco microsserviços possuem workflows independentes:

```text
analytics-ci.yaml
auth-ci.yaml
evaluation-ci.yaml
flag-ci.yaml
targeting-ci.yaml
```

Os workflows são acionados em:

- Pull Requests para `main`;
- Pushes para `main`;
- Alterações no diretório do serviço;
- Alterações no próprio workflow.

## Etapas

```text
Checkout
    ↓
Setup da linguagem
    ↓
Instalação das dependências
    ↓
Build
    ↓
Testes unitários
    ↓
Lint e análise estática
    ↓
SAST
    ↓
SCA
    ↓
Docker Build
    ↓
Container Scan
    ↓
Autenticação AWS
    ↓
Push para ECR
    ↓
Atualização GitOps
```

---

# 🧪 Build e testes

## Serviços Go

Ferramentas:

- `go build`;
- `go test`;
- `go vet`;
- GolangCI-Lint.

Serviços:

- Auth;
- Evaluation.

## Serviços Python

Ferramentas:

- Pytest;
- Flake8.

Serviços:

- Flag;
- Targeting;
- Analytics.

---

# 🔎 Lint e análise estática

## Go

O GolangCI-Lint agrega diferentes verificações de qualidade e identifica, por exemplo:

- Retornos de erro ignorados;
- Problemas de construção;
- Código potencialmente problemático;
- Inconsistências detectadas pelos linters habilitados.

Versão utilizada:

```text
golangci-lint v2.13.2
```

O binário é instalado com a mesma toolchain Go utilizada pelo projeto, evitando incompatibilidade entre a versão do compilador e a versão-alvo do módulo.

## Python

O Flake8 executa:

- Verificações bloqueantes de sintaxe;
- Identificação de nomes inválidos;
- Relatório completo de estilo;
- Análise de complexidade.

---

# 🛡️ SAST

SAST analisa padrões vulneráveis no código-fonte sem executar a aplicação.

## Go — Gosec

O Gosec identificou e permitiu corrigir:

- Erros ignorados;
- Possibilidade de log injection;
- Requisições HTTP potencialmente vulneráveis a SSRF;
- Uso inseguro de entradas externas.

As chamadas entre o Evaluation, Flag e Targeting passaram a utilizar:

```text
buildServiceURL
→ validação do protocolo
→ validação do host
→ whitelist do identificador
→ NewRequestWithContext
→ HttpClient.Do
```

## Python — Bandit

O Bandit foi utilizado para identificar padrões inseguros no Python.

Foram revisados:

- SQL construído dinamicamente;
- Bind em `0.0.0.0`;
- Exclusão dos testes do escopo de produção.

O bind em `0.0.0.0` foi documentado como decisão necessária para permitir que os containers recebam tráfego dos Services Kubernetes.

---

# 📦 SCA

SCA analisa bibliotecas e dependências utilizadas pela aplicação.

Ferramenta:

```text
Trivy filesystem scan
```

Política:

```text
severity: CRITICAL
exit-code: 1
```

Fluxo:

```text
Vulnerabilidade crítica encontrada
        ↓
Trivy retorna código 1
        ↓
Job falha
        ↓
Imagem não é publicada
        ↓
GitOps não é atualizado
```

---

# 🚨 Evidência de bloqueio

Durante a validação, o Trivy encontrou vulnerabilidades críticas em dependências Go e na toolchain utilizada pelas imagens.

O pipeline foi interrompido automaticamente.

A correção incluiu:

- Atualização de `golang.org/x/crypto`;
- Atualização das dependências transitivas;
- Atualização da versão Go;
- Atualização da imagem builder;
- Reconstrução das imagens sem cache;
- Reexecução dos testes;
- Reexecução do Gosec;
- Reexecução do Trivy.

Após a correção:

```text
Auth go.mod
CRITICAL: 0

Evaluation go.mod
CRITICAL: 0
```

Essa evidência demonstra o ciclo:

```text
Detectar
→ Bloquear
→ Corrigir
→ Validar
→ Aprovar
```

---

# 🐳 Containers

Os serviços Go usam multi-stage build.

```text
golang:1.26-alpine
        │
        ▼
Compilação do binário
        │
        ▼
alpine:3.20
        │
        ▼
Imagem final reduzida
```

Práticas aplicadas:

- Imagem final sem toolchain de compilação;
- Execução com usuário não-root;
- `CGO_ENABLED=0`;
- `GOOS=linux`;
- `-trimpath`;
- Remoção de símbolos com `-ldflags="-s -w"`;
- Instalação apenas de certificados necessários;
- Build utilizando `go.mod` e `go.sum` versionados.

---

# 🔍 Container Scan

Depois do Docker Build, o Trivy analisa a imagem completa:

- Pacotes do sistema operacional;
- Imagem-base;
- Bibliotecas;
- Binários Go;
- Dependências da aplicação.

Política:

```text
CRITICAL encontrada
→ Pipeline interrompido
```

---

# 🔑 Secret Scanning

Como melhoria adicional de DevSecOps, foi criado um workflow de Secret Scanning utilizando Gitleaks.

O objetivo é detectar acidentalmente:

- Tokens;
- Chaves de API;
- Credenciais AWS;
- Senhas;
- Strings semelhantes a segredos.

O Secret Scan executa em Pull Requests e pushes para `main`.

Os arquivos de exemplo documentam apenas os nomes das variáveis necessárias e nunca armazenam valores reais.

---

# 🔒 Gestão de credenciais

Não devem ser armazenados no Git:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_SESSION_TOKEN
GITOPS_TOKEN
DB_PASSWORD
Credenciais reais de banco
Tokens pessoais
```

Na execução final, as credenciais temporárias da AWS Academy serão cadastradas como GitHub Actions Secrets.

O arquivo `secrets.example.yaml` serve apenas como documentação e não contém valores reais.

---

# 🔄 GitOps

O repositório GitOps representa o estado desejado do Kubernetes.

Ao final do pipeline aprovado:

```text
Imagem publicada no ECR
        ↓
IMAGE_URI gerada com commit SHA
        ↓
Pipeline clona o repositório GitOps
        ↓
deployment.yaml é atualizado
        ↓
Commit automático
        ↓
Push para main
        ↓
ArgoCD detecta a mudança
        ↓
Sincronização com o EKS
```

O pipeline não executa deploy direto no cluster.

---

# 🚀 ArgoCD

Foi adotado o padrão App of Apps.

```text
root-app
│
├── platform-app
├── auth-app
├── flag-app
├── targeting-app
├── evaluation-app
└── analytics-app
```

Cada Application define:

- Repositório;
- Branch `main`;
- Caminho dos manifestos;
- Cluster de destino;
- Namespace de destino;
- Política de sincronização.

## Política

```yaml
automated:
  prune: true
  selfHeal: true
```

- `prune`: remove recursos que deixaram de existir no Git;
- `selfHeal`: corrige divergências entre o cluster e o estado declarado;
- `Synced`: estado aplicado corresponde ao Git;
- `Healthy`: recursos apresentam condição de saúde esperada.

---

# 🧰 Kustomize

Cada microsserviço contém:

```text
deployment.yaml
service.yaml
kustomization.yaml
```

O Kustomize renderiza os recursos antes da aplicação pelo ArgoCD.

Validações realizadas:

```text
apps/auth
apps/flag
apps/targeting
apps/evaluation
apps/analytics
platform
```

---

# 🌐 Estratégia de exposição

Os Services utilizam:

```yaml
type: ClusterIP
```

Os cinco microsserviços foram isolados em namespaces distintos.

O Ingress compartilhado foi mantido como proposta arquitetural, mas não está incluído no `platform/kustomization.yaml` da demonstração prática.

Uma evolução futura poderá usar:

- Ingress por namespace;
- Gateway central;
- AWS Load Balancer Controller;
- DNS;
- TLS;
- Certificados gerenciados.

---

# ✅ Validações realizadas

## Go

```bash
go test ./...
go vet ./...
golangci-lint run ./...
gosec -fmt=text ./...
```

## Python

```bash
pytest -v
flake8 .
bandit -r . -x tests -ll
```

## Docker

```bash
docker build --no-cache ...
```

## Trivy

```bash
trivy fs ...
trivy image ...
```

## Kubernetes

```bash
kubectl kustomize ...
```

## YAML

```bash
python3 -c "import yaml; ..."
```

## Secret Scan

```text
Gitleaks executado pelo GitHub Actions.
```

---


# 🔐 Secrets necessários para a execução final

No repositório Infra-apps:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_SESSION_TOKEN
GITOPS_TOKEN
```

As credenciais AWS são temporárias e devem ser atualizadas quando uma nova sessão do AWS Academy for iniciada.

---


---

# 👤 Responsável

Lucas Soares

---

# 🏁 Conclusão

A ToggleMaster foi estruturada para utilizar infraestrutura declarativa, pipelines com validações de segurança e entrega baseada em GitOps.

As alterações passam por Build, Testes, Lint, SAST, SCA, Secret Scan, Docker Build e Container Scan antes da publicação.

A infraestrutura é definida em Terraform, as imagens são versionadas no ECR e os deployments são controlados pelo repositório GitOps. O ArgoCD reconcilia o estado declarado com o cluster EKS.

O resultado é uma solução reproduzível, auditável, rastreável e preparada para evolução contínua.