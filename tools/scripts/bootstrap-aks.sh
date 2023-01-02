#!/bin/bash

set -e
set -u

clear
echo "############# Bootstrapping AKS Cluster #############"
AKS_CLUSTER="$CLUSTER-$ENV"
AKS_CLUSTER_CREATE_ARGS="${AKS_CREATE_ARGS:-''}"
RESOURCE_GROUP="$TEAM-$AKS_CLUSTER"
CLUSTER_ROOT="clusters/$CLUSTER"
CLUSTER_ENV_ROOT="clusters/$CLUSTER/$ENV"
SETTING_FILE="$CLUSTER_ENV_ROOT/settings/cluster-settings.sops.yaml"
GROUP_LOCATION="${LOCATION:-eastus}"
GROUP_EXISTS=$(az group exists -n $RESOURCE_GROUP>&1)

# Initiate with Azure
AZURE_INIT_RESULT=$(az account set --subscription d473b074-35c2-4b10-af8a-1bf5263232b5>&1)

function fail {
    printf '%s\n' "$1" >&2
    exit "${2-1}"
}

function create_resource_group {
  echo "Creating resource group '$RESOURCE_GROUP' ($GROUP_LOCATION). Please wait..."
  az group create --name $RESOURCE_GROUP --location $GROUP_LOCATION
}

function recreate_resource_group {
  echo "Deleting resource group '$RESOURCE_GROUP'. Please wait..."
  az group delete --name $RESOURCE_GROUP --yes
  create_resource_group
}

function print_info {
  echo "------------- Script Info -------------"
  echo "Team: $TEAM"
  echo "Cluster: $CLUSTER"
  echo "Environment: $ENV"
  echo "Azure Subscription: $SUBSCRIPTION"
  echo "Azure Resource Group: $RESOURCE_GROUP"
  echo "AKS Cluster Name: $AKS_CLUSTER"
  echo "Kube Config: $KUBECONFIG"
  echo "---------------------------------------"
}

function new_step {
  clear
  print_info
  echo ""
  echo "$1"
  echo ""
}

function confirm_info {
  print_info
  echo ""
  read -p "Does this info above look correct? Continue? (y/n) " DO_CONTINUE

  if echo $DO_CONTINUE | grep -q "y"; then
    echo ""
    echo "Checking if resource group already exists. Please wait..."
  else
    fail "Terminating process. No action has taken place."
  fi
}

print_info

# Create Resource Group
if echo $GROUP_EXISTS | grep -q "true"; then
  echo ""
  echo "Resource group '$RESOURCE_GROUP' already exists!"
  read -p "Do you want to recreate this group? (y/n) " DO_RECREATE_GROUP

  if echo $DO_RECREATE_GROUP | grep -q "y"; then
    echo ""
    recreate_resource_group
  fi
else
  create_resource_group
fi

# Create cluster
new_step "Creating AKS cluster. Please wait..."
CLUSTER_RESULT=$(az aks create -g $RESOURCE_GROUP -n $AKS_CLUSTER $AKS_CLUSTER_CREATE_ARGS>&1)

# Get access to cluster
new_step "Retrieving cluster config file. Please wait..."
AZURE_CREDS_RESULT=$(az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER --overwrite-existing>&1)

# Create public IP
# NOTE: the "resource group" sent to the public-ip create command is not the same resource group used elsewhere.
# See: https://learn.microsoft.com/en-us/azure/aks/ingress-tls?tabs=azure-cli
echo ""
echo "Creating public IP. Please wait..."
CLUSTER_RESOURCE_GROUP=$(az aks show --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER --query nodeResourceGroup -o tsv>&1)
PUBLIC_IP=$(az network public-ip create --resource-group $CLUSTER_RESOURCE_GROUP --name $AKS_CLUSTER --sku Standard --allocation-method static --query publicIp.ipAddress -o tsv>&1)

clear
echo "------------------------ Update settings ------------------------"
echo "A static public IP has been generated for this cluster."
echo "You must update the 'LOAD_BALANCER_IP' in the settings file for this cluster."
echo "After making the change, save, commit, and push your changes to Git."
echo ""
echo "Update 'LOAD_BALANCER_IP' setting to:"
echo ""
echo "$SETTING_FILE"
echo "LOAD_BALANCER_IP: $PUBLIC_IP"
echo ""
echo ""

echo "When the steps above are completed, press any key to continue..."
read

# Install FluxCD.
new_step "Installing FluxCD into cluster. Please wait..."
kubectl config set-context $AKS_CLUSTER

# Connect GitOps with cluster
new_step "Hooking up GitOps repository. Please wait..."
task cluster:verify
echo ""
task cluster:install

clear
echo ""
echo "#####################################################"
echo ""
echo ""
echo "Cluster bootstrap completed"
echo ""
echo "Check the status of the deployment: 'task cluster:kustomizations'"
echo "Configure DNS with public IP: '$PUBLIC_IP'"
