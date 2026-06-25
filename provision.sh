RESOURCE_GROUP="rg-leith-zniber-prf2026"
APP_NAME="c-est-l-appli-oui-c-est-oui"   # nom unique obligatoire
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

az webapp create \
    --name "$APP_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --plan "$APPSERVICE_PLAN"  \
    --runtime "PHP:8.2"

