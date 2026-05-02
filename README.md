# project_04

Local Kubernetes Vertical Pod Autoscaler (VPA) lab for the PC minikube cluster.

## Current target

- Cluster context: `minikube`
- Kubernetes: `v1.35.1`
- VPA release: `vertical-pod-autoscaler-1.6.0`
- Namespace: `project-04-vpa`

## Deploy

Install or refresh VPA system components:

```powershell
.\scripts\install-vpa.ps1
```

Deploy the VPA demo workload:

```powershell
.\scripts\deploy.ps1
```

Check recommendations after a few minutes:

```powershell
kubectl -n project-04-vpa describe vpa vpa-demo
kubectl -n project-04-vpa get pods
```

The demo uses `updateMode: InPlaceOrRecreate`, so VPA can update pod requests in
place when supported and recreate pods as a fallback.
