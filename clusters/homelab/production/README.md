# Production "homelab" Kubernetes Cluster

This is my "production" homelab Kubernetes cluster.

## Nodes

Master

- mini-1
- mini-2
- mini-3

Workers

- mini-4
- rasp-1
- rasp-2


## Environment

Kube-VIP IP: `192.168.7.200`
MetalLB Range:: `192.168.7.240-192.168.7.242`
Load Balancer IP: `192.168.7.240`

## Command Cheatsheet

### Recreate entire cluster from scratch:

```bash
export CLUSTER=homelab
export ENV=production
export KUBECONFIG="clusters/$CLUSTER/$ENV/kubeconfig"

task recreate
```
