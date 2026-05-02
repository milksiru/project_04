$ErrorActionPreference = "Stop"

kubectl apply -k k8s
kubectl -n project-04-vpa rollout status deployment/vpa-demo --timeout=180s

Write-Host "VPA demo namespace: project-04-vpa"
Write-Host "Recommendations: kubectl -n project-04-vpa describe vpa vpa-demo"
