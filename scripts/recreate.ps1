Write-Host "------ Executing: recreate ------"

& "$PSScriptRoot/recreate-cluster.ps1"
& Write-Host "------------------------"
& Write-Host "0) Check flux."
& flux check --pre
& Write-Host "------------------------"
& Write-Host "1) Bootstrap flux."
& kubectl apply --kustomize "$PSScriptRoot/../base/flux-system/bootstrap"
& Write-Host "------------------------"
& Write-Host "2) Create SOPS secret."
& kubectl -n flux-system create secret generic sops-age --from-file=age.agekey
& Write-Host "------------------------"
& Write-Host "3) Create FluxCD repo credentials secret."
& sops --decrypt "$PSScriptRoot/../clusters/homelab/ssh-keys.sops.yaml" | kubectl apply -f -
& Write-Host "------------------------"
& Write-Host "4) Link repository"
& kubectl apply --kustomize "$PSScriptRoot/../clusters/homelab/production/"
& Write-Host "------------------------"
& Write-Host "5) Reconciling"
& "$PSScriptRoot/reconcile.ps1"
