# Staging "homelab" Kubernetes Cluster

This cluster is used as the staging environment for my [production homelab clsuter](../production/README.md). This staging cluster is configured to consume the production cluster workloads, but with different settings.

## Nodes

Master

- 192.168.1.217 k3s-dev-1
- 192.168.1.10 k3s-dev-2

Workers

- 192.168.1.248 k3s-dev-3


## Environment

Kube-VIP IP: `192.168.6.200`
MetalLB Range:: `192.168.6.240-192.168.6.254`
Load Balancer IP: `192.168.6.240`

## Command Cheatsheet

### Recreate entire cluster from scratch:

```bash
export CLUSTER=homelab
export ENV=staging
export KUBECONFIG="clusters/$CLUSTER/$ENV/kubeconfig"

task recreate
```
