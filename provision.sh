#!/bin/bash

RESOURCE_GROUP="rg-leith-zniber-prf2026"
SHARED_RG="rg-shared-prf2026"
APP_NAME="c-est-l-appli-oui-c-est-oui"   # nom unique obligatoire
FUNC_NAME="c-est-la-fonction-oui-c-est-oui"   # nom unique obligatoire
STORE_NAME="cestlestore646845641973"   # nom unique obligatoire
LOCATION="francecentral"

# Créer le resource group
# az group create --name "$RESOURCE_GROUP" --location "$LOCATION"
# on a déjà un ressource group

# Créer le plan App Service (B1 — nécessaire pour Always On et la stabilité)
# az appservice plan create \
#     --name "plan-nexacloud" \
#     --resource-group "$RESOURCE_GROUP" \
#     --sku B1 \
#     --is-linux
#On utilise un appservice plan commun qui existe déjà 

APPSERVICE_PLAN="plan-npr-prf2026"

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
    --location "$LOCATION" \
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


if [[ $(az functionapp list --resource-group $SHARED_RG --query "[?name=='$FUNC_NAME'] | length(@)") > 0 ]]
then
  echo "functionapp $FUNC_NAME exists"
else
  echo "functionapp $FUNC_NAME doesn't exist, creating functionapp $FUNC_NAME"
  az functionapp create \
    --name "$FUNC_NAME" \
    --resource-group "$SHARED_RG" \
    --storage-account "$STORE_NAME" \
    --plan "$APPSERVICE_PLAN"  \
    --runtime "Python:3.11"
fi
