RESOURCE_GROUP="your-resource-group"
LOCATION="eastus"
KEYVAULT_NAME="k3s-prod-kv-$(date +%s)" 
CLUSTER_NAME="k3-master" 


# create a resource group 
az create --name $RESOURCE_GROUP --location $LOCATION


# create Key Vault 
az keyvault create  \
    --name $KEYVAULT_NAME \ 
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION \ 
    --sku standard \

# Create Service Principal for Workload Identity 
az ad sp create-for-rbac --name "k3s-workload-identity" \
    --role "Key Vault secrets User" \
    --scopes /subscriptions/$(az account show --query id -o tsv)/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.keyVault/vaults/$KEYVAULT_NAME 


# store secrets in key vaults 
az keyvault secret set --vault-name $KEYVAULT_NAME --name "mysql-root-password" --value "your-secure-root-password"
az keyvault secret set --vault-name $KEYVAULT_NAME --name "mysql-user" --value "app_user"
az keyvault secret set --vault-name $KEYVAULT_NAME --name "mysql-password" --value "your-secure-user-password"
az keyvault secret set --vault-name $KEYVAULT_NAME --name "mysql-database" --value "production_db"
az keyvault secret set --vault-name $KEYVAULT_NAME --name "jwt-secret-key" --value "your-jwt-secret-key"
az keyvault secret set --vault-name $KEYVAULT_NAME --name "api-key" --value "your-api-key"