# Azure Government OpenAI Access

![](arch1.png)

### Getting Started
This quickstart example uses Azure CLI to deploy a Docker container to Azure Container Instances in Azure Government based on code used in the [Azure OpenAI quickstart guide](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/quickstart?pivots=programming-language-python&tabs=command-line). This app demonstrates access to Azure OpenAI instance (which is a prerequisite) from an Azure Government subscription, directly connecting over the Microsoft’s private and secure backbone network (never connecting to the internet) as shown in architecture above.

### Prerequisites
- Access granted to Azure OpenAI in the desired Azure subscription. Currently, access to this service is granted only by application. You can apply for access to Azure OpenAI by completing the form at [https://aka.ms/oai/access](https://aka.ms/oai/access). Open an issue on this repo to contact us if you have an issue.
- An Azure OpenAI Service resource with a model deployed. For more information about model deployment, see the [resource deployment guide](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/how-to/create-resource).
- [Python 3.7.1 or later version](https://www.python.org/) with following Python libaries: os, requests, json
- Azure CLI. For more information, see [How to install the Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli).
After installing, sign in for the first time. For more information, see [How to sign into the Azure CLI](https://learn.microsoft.com/en-us/cli/azure/get-started-with-azure-cli#how-to-sign-into-the-azure-cli).
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
echo export AZURE_OPENAI_KEY="REPLACE_WITH_YOUR_KEY_VALUE_HERE" >> /etc/environment && source /etc/environment
echo export AZURE_OPENAI_ENDPOINT="REPLACE_WITH_YOUR_ENDPOINT_HERE" >> /etc/environment && source /etc/environment
```

### Create a container
Now that you have a resource group, you can run a container in Azure. To create a container instance with the Azure CLI, provide a resource group name, container instance name, and Docker container image to the az container create command.

```
az container create --resource-group myResourceGroup \
  --name agoa-container-group \
  --environment-variables ‘OPENAI_API_BASE=$AZURE_OPENAI_ENDPOINT, OPENAI_API_KEY=$AZURE_OPENAI_KEY’ \
  --image mycontainerregistry/agoa:v1/agoa:v1 \
  agoa
```

### Verify via container logs
Now that you have your container deployed, let’s check the logs to verify connectivity.

```
az container logs --resource-group myResourceGroup --name agoa
```

<SAMPLE OUTPUT>
