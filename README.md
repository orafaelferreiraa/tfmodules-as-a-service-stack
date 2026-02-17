# tfmodules-as-a-service-stack

Repositório de módulos Terraform reutilizáveis para provisionamento de infraestrutura Azure.

## Módulos disponíveis

| Módulo | Descrição | Documentação |
|--------|-----------|--------------|
| [azurerm_container_registry](modules/azurerm_container_registry) | Azure Container Registry (ACR) com RBAC automático, Managed Identity e Diagnostic Settings | — |

## Como usar

Referencie o módulo diretamente via Git:

```hcl
module "container_registry" {
  source = "git::https://github.com/orafaelferreiraa/tfmodules-as-a-service-stack.git//modules/azurerm_container_registry?ref=main"

  name                = "crMyAppEus2a1b2"
  location            = "eastus2"
  resource_group_name = "rg-myapp-eus2"
  sku                 = "Basic"
}
```

> Para detalhes de cada módulo (inputs, outputs, exemplos completos), consulte o README dentro da pasta do módulo.

---

## 🏗️ Arquitetura & Integração

### Estrutura do Módulo Terraform

```mermaid
flowchart LR
    subgraph "📂 Module Structure"
        A["variables.tf<br/>Input declarations"]
        B["main.tf<br/>Resource definitions<br/>& logic"]
        C["outputs.tf<br/>Output values"]
    end
    
    subgraph "🔧 Configuration"
        D["Variable Defaults<br/>type, default<br/>description, validation"]
        E["Terraform Resources<br/>azurerm_container_registry<br/>azurerm_role_assignment<br/>azurerm_user_assigned_identity<br/>azurerm_monitor_diagnostic_setting"]
        F["Computed Outputs<br/>Stable identifiers<br/>Connection details"]
    end
    
    subgraph "🚀 Deployment Flow"
        G["Consumer calls module<br/>with inputs"]
        H["Terraform reads<br/>variables.tf"]
        I["Executes main.tf<br/>Creates resources"]
        J["Outputs computed<br/>from outputs.tf"]
        K["Consumer receives<br/>outputs"]
    end
    
    A --> D
    B --> E
    C --> F
    
    G --> H
    H --> I
    I --> J
    J --> K
    
    D -.-> H
    E -.-> I
    F -.-> J
    
    style A fill:#1f6feb,stroke:#388bfd,color:#fff
    style B fill:#238636,stroke:#3fb950,color:#fff
    style C fill:#1f6feb,stroke:#388bfd,color:#fff
    style D fill:#0d1117,stroke:#388bfd,color:#fff
    style E fill:#0d1117,stroke:#3fb950,color:#fff
    style F fill:#0d1117,stroke:#388bfd,color:#fff
    style G fill:#161b22,stroke:#30363d,color:#fff
    style H fill:#1f6feb,stroke:#388bfd,color:#fff
    style I fill:#238636,stroke:#3fb950,color:#fff
    style J fill:#1f6feb,stroke:#388bfd,color:#fff
    style K fill:#161b22,stroke:#30363d,color:#fff
```

### Consumo & Integração

```mermaid
graph TB
    subgraph "📦 tfmodules-as-a-service-stack"
        direction TB
        A["azurerm_container_registry<br/>Terraform Module"]
        A --> B["📥 Inputs<br/>name, location<br/>resource_group_name, sku"]
        B --> C["⚙️ Module Logic<br/>ACR Creation<br/>RBAC Setup<br/>Managed Identity<br/>Diagnostics"]
        C --> D["📤 Outputs<br/>registry_id<br/>login_server<br/>principal_id"]
    end
    
    subgraph "🏗️ Consumer Projects"
        E["platform-as-a-service-stack<br/>terraform/main.tf"]
        F["Other Projects<br/>using modules"]
    end
    
    E -->|git::source| A
    F -->|git::source| A
    
    A -.->|Creates| H["🔒 Azure Container Registry<br/>+ RBAC + MI + Diagnostics"]
    
    style A fill:#0d1117,stroke:#388bfd,color:#fff,stroke-width:3px
    style B fill:#1f6feb,stroke:#388bfd,color:#fff
    style C fill:#238636,stroke:#3fb950,color:#fff
    style D fill:#1f6feb,stroke:#388bfd,color:#fff
    style E fill:#161b22,stroke:#30363d,color:#fff
    style F fill:#161b22,stroke:#30363d,color:#fff
    style H fill:#da3633,stroke:#f85149,color:#fff
```

### Validação & Release

```mermaid
flowchart TD
    A["🔀 PR: new module or update"] --> B["✅ GitHub Actions<br/>workflow_dispatch"]
    B --> C["📥 pipeline-as-a-service-stack<br/>pipeline-core.yaml"]
    C --> D["🔍 Stage 1: terraform fmt"]
    D --> E["🔍 Stage 2: TFLint<br/>Best practices"]
    E --> F["🔒 Stage 3: tfsec<br/>Security scanning"]
    F --> G["📋 Stage 4: Checkov<br/>Policy compliance"]
    G --> H["📚 Stage 5: terraform-docs<br/>Auto-generate module docs"]
    H --> I{"All stages<br/>passed?"}
    I -->|Yes| J["✅ Merge approved<br/>Module published"]
    I -->|No| K["❌ Requires fixes<br/>Review feedback"]
    
    J --> L["🚀 Module available<br/>via git::source"]
    L --> M["📦 Consumers can use<br/>in their terraform code"]
    K --> A
    
    style A fill:#0d1117,stroke:#388bfd,color:#fff,stroke-width:2px
    style B fill:#0d1117,stroke:#388bfd,color:#fff,stroke-width:2px
    style C fill:#388bfd,stroke:#388bfd,color:#fff,stroke-width:2px
    style D fill:#1f6feb,stroke:#388bfd,color:#fff
    style E fill:#1f6feb,stroke:#388bfd,color:#fff
    style F fill:#da3633,stroke:#f85149,color:#fff
    style G fill:#1f6feb,stroke:#388bfd,color:#fff
    style H fill:#238636,stroke:#3fb950,color:#fff
    style I fill:#0d1117,stroke:#388bfd,color:#fff
    style J fill:#238636,stroke:#3fb950,color:#fff
    style K fill:#da3633,stroke:#f85149,color:#fff
    style L fill:#238636,stroke:#3fb950,color:#fff
    style M fill:#238636,stroke:#3fb950,color:#fff
```

---

## Estrutura

```
tfmodules-as-a-service-stack/
└── modules/
    └── azurerm_container_registry/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Requisitos

| Nome | Versão |
|------|--------|
| Terraform | >= 1.9.0 |
| azurerm | ~> 4.57 |
