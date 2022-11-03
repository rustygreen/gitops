# k3d
echo "Deleting local cluster";
k3d cluster delete homelab;
echo "Creating local cluster";
k3d cluster create homelab --api-port 0.0.0.0:6550 --servers 1 --agents 1 --port "80:80@loadbalancer" --port "443:443@loadbalancer" --k3s-arg "--no-deploy=traefik@server:0";

# minkube
# echo "Deleting local cluster";
# minikube delete --all
# echo "Creating local cluster";
# minikube start