# Azure Government OpenAI Access
<ARCHITECUTRE HERE>
## Getting Started
This quickstart example uses Azure CLI to deploy an isolated Docker container to Azure Container Instances in Azure Government based on code used in the [Azure OpenAI quickstart guide](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/quickstart?pivots=programming-language-python&tabs=command-line). This app will directly connect over the Microsoft’s private and secure backbone network (never connecting to the internet) as noted in Figure 1 below and accessing your deployed Azure OpenAI service within Azure Commercial. 

### Prerequisites
-	All prerequisites from [Azure OpenAI quickstart guide](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/quickstart?pivots=programming-language-python&tabs=command-line).
-	Use the Bash environment in [Azure Cloud Shell](https://learn.microsoft.com/en-us/azure/cloud-shell/overview) within Azure Government. For more information, see [Quickstart for Bash in Azure Cloud Shell](https://learn.microsoft.com/en-us/azure/cloud-shell/quickstart).
- Knowledge of Docker CLI operations (e.g. tagging, creating images)


### Setting Cloud

To deploy in Azure Gov please set the cloud as Follows

```
az cloud set --name AzureUSGovernment 
```

### Create a resource group
Azure container instances, like all Azure resources, must be deployed into a resource group. Resource groups allow you to organize and manage related Azure resources.

First, create a resource group named `myResourceGroup` in the `usgovvirginia` location with the following az group create command:

```
az group create --name myResourceGroup --location usgovvirginia
```

### Create an Azure Container Registry and Log in to registry

- [Create Azure Container Registry](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-get-started-azure-cli#create-a-container-registry)
- [Log in to Container Registry](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-get-started-azure-cli#create-a-container-registry)

### Tag and push container image 

```
az acr create --resource-group myResourceGroup \
  --name mycontainerregistry --sku Basic
az acr login --name mycontainerregistry
docker build agoa mycontainerregistry/agoa:v1
docker push mycontainerregistry/agoa:v1
```

### Set Azure OpenAI Environment Variables
Azure container instances can take in environment variables at runtime, which are used within the Python container app.

```
$export OPENAI_API_BASE=”REPLACE_WITH_YOUR_ENDPOINT_HERE”
$ export OPENAI_API_KEY=”REPLACE_WITH_YOUR_API_KEY_HERE”
```

### Create a container
Now that you have a resource group, you can run a container in Azure. To create a container instance with the Azure CLI, provide a resource group name, container instance name, and Docker container image to the az container create command.

```
az container create --resource-group myResourceGroup \
  --name agoa-container-group \
  --environment-variables ‘OPENAI_API_BASE=$OPENAI_API_BASE, OPENAI_API_KEY=$OPENAI_API_KEY’ \
  --image mycontainerregistry/agoa:v1/agoa:v1 \
  agoa
```

### Verify via container logs
Now that you have your container deployed, let’s check the logs to verify connectivity.

```
az container logs --resource-group myResourceGroup --name agoa
```

<SAMPLE OUTPUT>
