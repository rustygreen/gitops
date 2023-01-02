# Homelab Kubernetes Cluster

A mono repository for my home infrastructure and Kubernetes cluster which adheres to Infrastructure as Code (IaC) and GitOps practices where possible

## Prerequisites

1. Install [go-task](https://github.com/go-task/task) via Brew
> brew install go-task/tap/go-task
2. Install workstation dependencies via Brew
> task init

## Bootstrap

```bash
export CLUSTER=homelab
export ENV=staging
export KUBECONFIG="clusters/$CLUSTER/$ENV/kubeconfig"

task recreate
```

## TODOs
- Add more documentation
- [ ] Upgrade to latest K3s version (currently limited to 1.24 due to (longhorn #4003)[https://github.com/longhorn/longhorn/issues/4003] )

## Resources
- TODO