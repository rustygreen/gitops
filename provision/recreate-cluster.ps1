# k3d
echo "Deleting local cluster";
k3d cluster delete homelab;
echo "Creating local cluster";
k3d cluster create homelab;

# minkube
# echo "Deleting local cluster";
# minikube delete --all
# echo "Creating local cluster";
# minikube start