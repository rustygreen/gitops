## Bootstrap

```bash
# 0) Check.
flux check --pre
# 1) Bootstrap flux.
kubectl apply --kustomize ./base/flux-system/bootstrap
# 2) Create SOPS secret.
kubectl -n flux-system create secret generic sops-age --from-file=age.agekey
# 3) Create FluxCD repo credentials secret.
sops --decrypt clusters/homelab/ssh-key.sops.yaml | kubectl apply -f -
# 4) Link repository
kubectl apply --kustomize clusters/homelab/production/
```

## Maintenance

```bash
# Reconcile
flux reconcile -n flux-system source git flux-cluster

flux reconcile -n flux-system kustomization flux-cluster
```

# Local
```bash
k3d cluster create homelab
```