
# echo "Deleting cluster homelab";
# k3d cluster delete homelab;
# echo "Creating cluster homelab";
# k3d cluster create homelab;

echo "Deleting local cluster";
minikube delete --all
echo "Creating local cluster";
minikube start