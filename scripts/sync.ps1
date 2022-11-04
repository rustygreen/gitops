Write-Host "------ Committing & reconciling ------"
& git add -A
& git commit -m "refactor: updates workloads"
& git push
& git pull
& "$PSScriptRoot/reconcile.ps1"
& Write-Host "------------------------------------"
