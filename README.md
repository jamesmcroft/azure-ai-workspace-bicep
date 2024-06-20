# Azure AI Hub Bicep Templates for Azure AI Studio

This repository contains the necessary Bicep templates to spin up an Azure AI Hub in the [new Azure AI Studio](https://azure.microsoft.com/en-gb/products/ai-studio/).

The new Azure AI Hub brings together all the features of Azure OpenAI Service, Azure Machine Learning, and other Azure AI Services into a single place. The advantages of the Azure AI Hub include:

- [Leveraging more open-source models](https://learn.microsoft.com/en-us/azure/ai-studio/how-to/model-catalog) for chat, completions, embeddings, text generation, speech recognition, image classification and more, alongside the OpenAI GPT models.
- Create and manage indexes to [customize generative AI responses using your own data](https://learn.microsoft.com/en-us/azure/ai-studio/how-to/index-add).
- Generate content filters over your model endpoints to [create responsible AI experiences](https://www.microsoft.com/en-us/ai/responsible-ai).
- Evaluate, build, test, and deploy your generative AI solutions using [Prompt Flow](https://learn.microsoft.com/en-us/azure/ai-studio/how-to/prompt-flow).

## Getting Started

To deploy the Azure AI Hub, you will need to:

### Prerequisites

- Install [**PowerShell Core**](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.1).
- Install the [**Azure CLI**](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).

### Deploy the Azure AI Hub

The **[main.bicep](./infra/main.bicep)** template contains all the necessary modules to deploy a complete Azure AI Hub including:

- Azure Resource Group, to contain all the resources.
- [Azure Managed Identity](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview), to provide RBAC to the Azure AI Hub with other resources.
- [Azure Storage Account](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-overview), to store workspace data, and to provide a place for your data.
- [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/overview), to store secrets and keys.
- [Azure Log Analytics Workspace](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview), to store logs and metrics.
- [Azure Container Registry](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-intro), to store model images for deployment.
- [Azure AI Services](https://learn.microsoft.com/en-us/azure/ai-services/what-are-ai-services), to provide the Azure AI Hub with access to Azure OpenAI and other Cognitive Services.
- [Azure AI Hub](https://learn.microsoft.com/en-us/azure/ai-studio/what-is-ai-studio?tabs=home), to provide an environment for you to build, test, and deploy your AI solutions.
- [Azure AI Search](https://learn.microsoft.com/en-us/azure/search/search-what-is-azure-search) (optional), to provide a search index over your data.

#### Configure the deployment parameters

The **[main.bicepparam](./infra/main.bicepparam)** file contains all the necessary parameters to deploy a complete Azure AI Hub including:

- workloadName, used as the suffix for the resource group name, and generate unique names for each deployed resource.
- location, used to specify the Azure region to deploy the Azure AI Hub.
- includeSearch, used to specify whether to include Azure AI Search in the deployment for indexing data.

#### Using PowerShell &amp; Azure CLI

To deploy the Azure AI Hub using PowerShell and the Azure CLI:

1. Clone this repository.
2. Open a PowerShell terminal at the [infra](./infra) folder.
3. Login to Azure using the Azure CLI and get a subscription ID.

```powershell
az login
$subscriptionId = ((az account list -o json --query "[?isDefault]") | ConvertFrom-Json).id
az account set --subscription $subscriptionId
```

4. Deploy the [main.bicep](./infra/main.bicep) template using the Azure CLI.

```powershell
az deployment sub create --name 'ai-hub' --location westeurope --template-file ./main.bicep --parameters ./main.bicepparam
```
