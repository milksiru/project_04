$ErrorActionPreference = "Stop"

$release = "1.6.0"
$tag = "vertical-pod-autoscaler-$release"
$workDir = Join-Path $env:TEMP "autoscaler-vpa-$release"
$bash = "C:\Program Files\Git\bin\bash.exe"

if (-not (Test-Path $bash)) {
  throw "Git Bash not found at $bash"
}

if (Test-Path $workDir) {
  Remove-Item -Recurse -Force $workDir
}

git clone --depth 1 --branch $tag https://github.com/kubernetes/autoscaler.git $workDir

$certScript = Join-Path $workDir "vertical-pod-autoscaler\pkg\admission-controller\gencerts.sh"
(Get-Content $certScript) -replace 'TMP_DIR="/tmp/vpa-certs"', 'TMP_DIR="./vpa-certs"' | Set-Content $certScript -NoNewline:$false

$bashWorkDir = $workDir.Replace("\", "/").Replace("C:", "/c")

$existingVpa = kubectl get crd verticalpodautoscalers.autoscaling.k8s.io --ignore-not-found
if ($existingVpa) {
  & $bash -lc "export MSYS_NO_PATHCONV=1; cd '$bashWorkDir/vertical-pod-autoscaler' && ./hack/vpa-down.sh"
}

& $bash -lc "export MSYS_NO_PATHCONV=1; cd '$bashWorkDir/vertical-pod-autoscaler' && ./hack/vpa-up.sh"

kubectl -n kube-system rollout status deployment/vpa-recommender --timeout=180s
kubectl -n kube-system rollout status deployment/vpa-updater --timeout=180s
kubectl -n kube-system rollout status deployment/vpa-admission-controller --timeout=180s

Write-Host "VPA $release installed on current kubectl context."
