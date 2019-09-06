[![pipeline status](https://gitlab.com/gamepod/agent/badges/master/pipeline.svg)](https://gitlab.com/gamepod/agent/commits/master) ![GitHub](https://img.shields.io/github/license/deploygamepod/agent?color=0677b8) [![Go Report Card](https://goreportcard.com/badge/github.com/deploygamepod/agent)](https://goreportcard.com/report/github.com/deploygamepod/agent)

# Gamepod Agent

The agent is the Kubernetes operator that sits in your clusters and manages the actual game server pods. The agent is responsible for creating and updating pods, managing storage, networking, and managing configuration files as config drives.

# Deploying

## Manually 

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

### Development

When testing on the local machine with a local build, deploy the `operator.build.yaml` file instead of `operator.yaml`.
```
# Deploy the operator
kubectl create -f deploy/operator.build.yaml
```

## Operator Lifecycle Manager (operatorhub.io)

First create an OperatorGroup for the namespace you want the operator to operate in.

```
cat <<EOF | kubectl apply -f -
apiVersion: operators.coreos.com/v1alpha2
kind: OperatorGroup
metadata:
  name: memcached-operator-group
  namespace: default
spec:
  targetNamespaces:
  - default
EOF
```

Now apply the Cluster Service Version to the cluster.
```
curl -Lo gamepodoperator.0.0.1.csv.yaml https://raw.githubusercontent.com/operator-framework/getting-started/master/gamepodoperator.0.0.1.csv.yaml
kubectl apply -f gamepodoperator.0.0.1.csv.yaml

# Check the deployment status
kubectl get ClusterServiceVersion gamepodoperator.v0.0.1 -o json | jq '.status'
```

Finally, apply the operator resource definitions and service account RBAC.
```
# Apply the CRUDs and RBAC
kubectl create -f deploy/crds/gamepod_v1alpha1_gameserver_crd.yaml
kubectl create -f deploy/service_account.yaml
kubectl create -f deploy/role.yaml
kubectl create -f deploy/role_binding.yaml
```


# Building

## Local

Ensure you have the latest version (v0.10.x) of the [Operator Framework SDK](https://github.com/operator-framework/operator-sdk/blob/master/doc/user/install-operator-sdk.md) installed.

Build the development version of the operator using the Operator SDK.
```
operator-sdk build gamepod/agent:build
```

Now you can test using the local Docker image `gamepod/agent:build`.

## Operator Lifecycle Manager (operatorhub.io)

We need to generate the Cluster Service Version manifest. Ensure to specify the previous version so that Operator versions can be properly updated.

```
operator-sdk olm-catalog gen-csv --csv-version CURRENT_VERSION --from-version PREVIOUS_VERSION
```

# Development

## Client Gen

Install the code-generation tools (run outside of project directory).
```
go get k8s.io/code-generator/...
```

Run the client generator inside the project directory.
```
make gen-clientset
```
