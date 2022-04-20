if [ -f .env ]
then
  export $(cat .env | xargs)
fi

echo "Sample Microservices"
accountId=$ACCOUNT_ID
location=$LOCATION

# # Generate a unique suffix for the service name
randomNum=$RANDOM

samplerg=ac-mcwa-lab-$randomNum-rg
uniqueAcr=$UNIQUE_ACR

az account set -s $accountId

az group create -n $samplerg -l $location

# The ACR that will hold all images in Azure
az acr create \
    -g $samplerg \
    --name $uniqueAcr \
    --sku Basic \
    --admin-enabled

ACR_KEY=$(az acr credential show -n $uniqueAcr --query "passwords[0].value" -o tsv)

docker build -t site:latest -f ../src/Site.External/Dockerfile ../.
docker build -t api:latest -f ../src/Api.Internal/Dockerfile ../.
docker build -t proxy:latest -f ../proxy/Dockerfile ../.

docker tag site:latest $uniqueAcr.azurecr.io/site:0.1
docker tag api:latest $uniqueAcr.azurecr.io/api:0.1
docker tag proxy:latest $uniqueAcr.azurecr.io/proxy:1.14.2
docker tag redis:alpine $uniqueAcr.azurecr.io/redis:alpine

az acr login --name $uniqueAcr

docker push $uniqueAcr.azurecr.io/site:0.1
docker push $uniqueAcr.azurecr.io/api:0.1
docker push $uniqueAcr.azurecr.io/proxy:1.14.2
docker push $uniqueAcr.azurecr.io/redis:alpine

# The app service az-mcwa-lab will live on
az appservice plan create \
    --name az-mcwa-lab-plan$randomNum \
    --resource-group $samplerg \
    --sku B1 \
    --is-linux

# Creates the multicontainergroup Web app
az webapp create \
    -g $samplerg \
    --plan az-mcwa-lab-plan$randomNum \
    --name az-mcwa-lab$randomNum \
    --multicontainer-config-type compose \
    --multicontainer-config-file ../mcwa-docker-compose.yml \
    -w $ACR_KEY \
    -s $uniqueAcr

az webapp config appsettings set \
    -g $samplerg \
    -n az-mcwa-lab$randomNum \
    --settings DOCKER_REGISTRY_SERVER_PASSWORD=$ACR_KEY DOCKER_REGISTRY_SERVER_USERNAME=$uniqueAcr

echo "Done :)"
