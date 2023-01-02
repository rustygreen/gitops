# Local Kubernetes Cluster

This is a locally running cluster meant for development and testing purposes. The cluster will run using [k3d](https://k3d.io/).

## Getting Start

### Dependencies

1. Ensure Docker is running
2. Ensure [k3d](https://k3d.io/) is installed
3. Ensure port 80 and 443 are not bound on your machine (disable IIS, etc.)
4. Run the following command from a Powershell terminal:

### Create cluster:

The following command can be ran to create or re-create the cluster locally. Note, if this command is running and the cluster is already created/running it will delete the existing cluster first, before creating the new one.

From Windows Powershell terminal:

```
powershell -file ./tools/scripts/recreate.ps1 -Cluster local
```

Check the status of the cluster setup:

```
kubectl get kustomizations -A
```

#### Local hosts file setup:
Launch the Dashboard: https://kube-dash.{PRIMARY_DOMAIN}
> NOTE: You'll need to add a hosts entry to point `kube-dash.{PRIMARY_DOMAIN}` to `127.0.0.1` (plus whatever other routes you plan to use)

Example:

```
127.0.0.1 kube-dash.my-domain.local
```
