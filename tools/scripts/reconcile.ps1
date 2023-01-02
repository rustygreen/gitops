$WaitSeconds = 5;

Write-Host "Reconciling cluster"
& flux reconcile -n flux-system source git flux-cluster;
& flux reconcile -n flux-system kustomization flux-cluster;
Write-Host "Waiting $WaitSeconds seconds to check status..."
& Start-Sleep -Seconds $WaitSeconds;
& kubectl get kustomizations -A;

Write-Host "-----------------"
Write-Host "Check status again with command: 'kubectl get kustomizations -A'"
