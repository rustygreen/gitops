Write-Host "------ Committing & reconciling ------"
& git add -A
& git commit -m "refactor: updates workloads"
& "$PSScriptRoot/reconcile.ps1"
& Write-Host "------------------------------------"
