#!/bin/bash

RESOURCE_GROUP="lzniberRG"
APP_NAME="c-est-l-appli-oui-c-est-oui"   # nom unique obligatoire
FUNC_NAME="c-est-la-fonction-oui-oui-c-est-oui"   # nom unique obligatoire
STORE_NAME="cestlestore618673641973" # nom unique obligatoire
ACI_NAME="je-sais-plus-quoi-mettre"  # nom unique obligatoire


if [[ $(az webapp list --resource-group $RESOURCE_GROUP --query "[?name=='$APP_NAME'] | length(@)") > 0 ]]
then
  echo "deleting webapp $APP_NAME "
  az webapp delete \
    --name "$APP_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --keep-empty-plan
else
  echo "webapp $APP_NAME doesn't exist"
fi


if [[ $(az functionapp list --resource-group $RESOURCE_GROUP --query "[?name=='$FUNC_NAME'] | length(@)") > 0 ]]
then
  echo "deleting functionapp $FUNC_NAME"
  az functionapp delete \
    --name "$FUNC_NAME" \
    --resource-group "$RESOURCE_GROUP" 
else
  echo "functionapp $FUNC_NAME doesn't exist"
fi


if [[ $(az container  list --resource-group $RESOURCE_GROUP --query "[?name=='$ACI_NAME'] | length(@)") > 0 ]]
then
  echo "deleting container instance $ACI_NAME"
  az container delete \
    --name "$ACI_NAME" \
    --resource-group "$RESOURCE_GROUP" 
else
  echo "container instance $ACI_NAME doesn't exist"
fi


# if [[ $(az storage account list --resource-group $RESOURCE_GROUP --query "[?name=='$STORE_NAME'] | length(@)") > 0 ]]
# then
#   echo "deleting storage $STORE_NAME"
#   az storage account delete \
#   --name "$STORE_NAME" \
#   --resource-group "$RESOURCE_GROUP" 
# else
#   echo "storage $STORE_NAME doesn't exist"
# fi