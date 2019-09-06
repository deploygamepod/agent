# Gamepod Agent

The agent is the Kubernetes operator that sits in your clusters and manages the actual game server pods. The agent is responsible for creating and updating pods, managing storage, networking, and managing configuration files as config drives.

# Installing

The operator can manually be installed via kubectl resource files provided by the repository.

```
# Create the Service Account
kubectl create -f deploy/service_account.yaml

# Config RBAC for the Service Account
kubectl create -f deploy/role.yaml
kubectl create -f deploy/role_binding.yaml

# Deploy the CRUDs
kubectl create -f deploy/crds/gamepod_v1alpha1_gameserver_crd.yaml

# Deploy the operator
kubectl create -f deploy/operator.yaml
```

# Building