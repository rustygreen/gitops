flux reconcile -n flux-system source git flux-cluster;
flux reconcile -n flux-system kustomization flux-cluster;
kubectl get kustomizations -A;