# Production "homelab" Kubernetes Cluster

This is my "production" homelab Kubernetes cluster.

## Nodes

Master

- mini-1
- mini-2
- mini-3

Workers

- mini-4 (currently out of commission)
- rasp-1
- rasp-2


## Environment

Kube-VIP IP: `192.168.7.200`
MetalLB Range:: `192.168.7.240-192.168.7.242`
Load Balancer IP: `192.168.7.240`

## Command Cheatsheet

### Recreate entire cluster from scratch:

NOTE: this cluster requires this set of commands to be ran instead of just simply running `task recreate` because of the taints that need to be applied to the nodes prior to bootstraping Flux.

TODO: Determine if there is a way to declare labels/taints via manifests.

Pre re-creating this cluster steps:

1. Update database recovery/backup versions when re-creating cluster
2. Remove router DNS pointing to cluster blocky service (set to "Auto")

```bash
export CLUSTER=homelab
export ENV=production
export KUBECONFIG="clusters/$CLUSTER/$ENV/kubeconfig"

task ansible:nuke
sleep 5 & echo Cluster destroyed
task install

kubectl taint nodes rasp-1 site=basement:NoSchedule
kubectl label nodes rasp-1 site=basement

kubectl taint nodes rasp-2 site=cowport:NoSchedule
kubectl label nodes rasp-2 site=cowport

kubectl taint nodes rasp-3 site=chickens:NoSchedule
kubectl label nodes rasp-3 site=chickens

task cluster:install
```

Post re-creating this cluster steps:

1. Update router DNS to point to blocky service IP: 192.168.7.202


# Preparing Raspberry Pis

Enable `cgroups` by appending `cgroup_memory=1 cgroup_enable=memory` to `/boot/cmdline.txt`

Example:
```bash
console=serial0,115200 console=tty1 root=PARTUUID=58b06195-02 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait cgroup_memory=1 cgroup_enable=memory
```

See [docs here](https://docs.k3s.io/advanced#raspberry-pi)
