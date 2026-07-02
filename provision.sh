#!/bin/bash

export MSYS_NO_PATHCONV=1

RESOURCE_GROUP="lzniberRG"
APP_NAME="c-est-l-appli-oui-c-est-oui"   # nom unique obligatoire
FUNC_NAME="c-est-la-fonction-oui-oui-c-est-oui"   # nom unique obligatoire
STORE_NAME="cestlestore618673641973" # nom unique obligatoire
ACI_NAME="je-sais-plus-quoi-mettre"  # nom unique obligatoire
LOCATION="francecentral"

# Créer le resource group
# az group create --name "$RESOURCE_GROUP" --location "$LOCATION"
# on a déjà un ressource group

# APPSERVICE_PLAN="plan-gang-leith"

# #Créer le plan App Service (B1 — nécessaire pour Always On et la stabilité)
# if [[ $(az appservice plan list --resource-group $RESOURCE_GROUP --query "[?name=='$APPSERVICE_PLAN'] | length(@)") > 0 ]]
# then
#   echo "plan app service $APP_NAME exists"
# else
#   az appservice plan create \
#       --name "$APPSERVICE_PLAN" \
#       --resource-group "$RESOURCE_GROUP" \
#       --sku B1 \
#       --is-linux
# fi

#On utilise le appservice plan partagé
APPSERVICE_PLAN="plan-npr-prf2026"
PLAN_ID="/subscriptions/5e683e0f-b00c-48d6-9769-5aaf598de8f1/resourceGroups/rg-shared-prf2026/providers/Microsoft.Web/serverfarms/plan-npr-prf2026"

# Source - https://stackoverflow.com/a/67384869
# Posted by Grilse
# Retrieved 2026-06-25, License - CC BY-SA 4.0

if [[ $(az webapp list --resource-group $RESOURCE_GROUP --query "[?name=='$APP_NAME'] | length(@)") > 0 ]]
then
  echo "webapp $APP_NAME exists"
else
  echo "webapp $APP_NAME doesn't exist, creating webapp $APP_NAME"
  az webapp create \
    --name "$APP_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --plan "$APPSERVICE_PLAN"  \
    --runtime "PHP:8.2"
fi



if [[ $(az storage account list --resource-group $RESOURCE_GROUP --query "[?name=='$STORE_NAME'] | length(@)") > 0 ]]
then
  echo "storage $STORE_NAME exists"
else
  echo "storage $STORE_NAME doesn't exist, creating storage $STORE_NAME"
  az storage account create \
  --name "$STORE_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION"
fi


if [[ $(az functionapp list --resource-group $RESOURCE_GROUP --query "[?name=='$FUNC_NAME'] | length(@)") > 0 ]]
then
  echo "functionapp $FUNC_NAME exists"
else
  echo "functionapp $FUNC_NAME doesn't exist, creating functionapp $FUNC_NAME"
  az functionapp create \
    --name "$FUNC_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --storage-account "$STORE_NAME" \
    --plan "$PLAN_ID"  \
    --runtime "Python"
fi

if [[ $(az container  list --resource-group $RESOURCE_GROUP --query "[?name=='$ACI_NAME'] | length(@)") > 0 ]]
then
  echo "container instance $ACI_NAME exists"
else
  echo "container instance $ACI_NAME doesn't exist, creating container instance $ACI_NAME"
  az functionapp create \
    --name "$ACI_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --storage-account "$STORE_NAME" \
    --plan "$APPSERVICE_PLAN"  \
    --location "$LOCATION" \
    --image mcr.microsoft.com/azuredocs/aci-helloworld \
    --os-type linux \
    --cpu 1 \
    --memory 1.5 \
    --ip-address "public" \
    --dns-name-label "api-aci-leith" \
    --ports 80
fi
