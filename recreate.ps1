echo "Deleting cluster homelab"
k3d cluster delete homelab
echo "Creating cluster homelab"
k3d cluster create homelab
echo "0) Check flux."
flux check --pre
echo "1) Bootstrap flux."
kubectl apply --kustomize ./base/flux-system/bootstrap
echo "2) Create SOPS secret."
kubectl -n flux-system create secret generic sops-age --from-file=age.agekey
echo "3) Create FluxCD repo credentials secret."
sops --decrypt clusters/homelab/ssh-key.sops.yaml | kubectl apply -f -
echo "4) Link repository"
kubectl apply --kustomize clusters/homelab/production/
echo "5) Reconciling"
flux reconcile -n flux-system source git flux-cluster
flux reconcile -n flux-system kustomization flux-cluster
