param (
    [string]$Cluster
)

echo "Deleting k3d cluster '$Cluster'";
k3d cluster delete $Cluster;
echo "Creating k3d cluster '$Cluster'";
k3d cluster create $Cluster --api-port 0.0.0.0:6550 --servers 1 --agents 1 --port "80:80@loadbalancer" --port "443:443@loadbalancer" --k3s-arg "--no-deploy=traefik@server:0";
