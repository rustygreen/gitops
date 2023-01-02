param (
    [string]$Cluster,
    [string]$Env
)
Write-Host "------------------------"
Write-Host "Executing 'recreate' for cluster '$Cluster' and environment '$Env'"

$ProjectRoot = "$PSScriptRoot/../..";
$ClusterRoot = "$ProjectRoot/clusters/$Cluster";
$FluxClusterRoot = "$ProjectRoot/base/flux-system";
$ClusterSopsFile = "$ClusterRoot/age.agekey";
$MachineSopsFile = "$env:APPDATA/sops/age/keys.txt";
$ClusterSopsExists = Test-Path -Path "$ClusterSopsFile" -PathType Leaf
$MachineSopsExists = Test-Path -Path "$MachineSopsFile" -PathType Leaf
# TODO: Make this configurable and not hard coded to k3d - @russell.green
$ClusterType = "k3d"

if (-not($ClusterSopsExists) -and -not($MachineSopsExists)) {
    Write-Error "SOPS key file does not exist." -ErrorAction Stop
    $host.SetShouldExit(1)
    exit
}

if (-not($ClusterSopsExists)) {
    Write-Host "Copying user SOPS file to cluster directory"
    Copy-Item $MachineSopsFile -Destination $ClusterSopsFile
}

Write-Host "Project root: '$ProjectRoot'"
Write-Host "Cluster root: '$ClusterRoot'"
Write-Host "SOPs file: '$ClusterSopsFile'"
Write-Host "------------------------"

& powershell -file "$PSScriptRoot/$ClusterType/recreate-cluster.ps1" -Cluster $Cluster
& Write-Host "------------------------"
& Write-Host "0) Check flux."
& flux check --pre
& Write-Host "------------------------"
& Write-Host "1) Bootstrap flux."
& kubectl apply --kustomize "$FluxClusterRoot/bootstrap"
& Write-Host "------------------------"
& Write-Host "2) Create SOPS secret."
& kubectl -n flux-system create secret generic sops-age --from-file=$ClusterSopsFile
& Write-Host "------------------------"
& Write-Host "3) Create FluxCD repo credentials secret."
& sops --decrypt "$FluxClusterRoot/repository/git-repo-ssh-keys.sops.yaml" | kubectl apply -f -
& Write-Host "------------------------"
& Write-Host "4) Link repository"
& Start-Sleep -Seconds 2;
& kubectl apply --kustomize "$ClusterRoot/$Env"
& Write-Host "------------------------"
& Write-Host "5) Reconciling"
& Write-Host ""
& Write-Host ""
& Write-Host "Congratulations, the cluster has been created"
& "$PSScriptRoot/reconcile.ps1"
