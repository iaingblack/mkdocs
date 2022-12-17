

# Basic Commands

## Install Kubectl

```bash
sudo snap install kubectl --classic
```

## Install KIND

```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
sudo mv kind /usr/bin/kind
sudo chmod +x /usr/bin/kind
```

## Create a Local Cluster

```bash
kind create cluster --name k8s1
...
kubectl cluster-info --context kind-k8s1
```

## Change Context

```bash
kubectl config use-context kind-k8s2
```

## Delete Cluster

```bash
kind delete cluster --name=k8s1
```

## Create a Cluster on the Local Network

Create a cluster file called kind.yml and expose on the local network

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: workers
networking:
  ipFamily: ipv4
  apiServerAddress: 192.168.1.70
  apiServerPort: 45001
```

Create the cluster

```bash
sudo kind create cluster --config=kind.yaml
```

## Get Token

```bash
kubectl get -n kube-system secret $(kubectl get -n kube-system sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"
```

# RBAC and Users

## Admin User

Create a file called [admin-user-serviceaccount.yaml](./assets/admin-user-serviceaccount.yaml)

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kube-system
```

## RBAC Admin User

Cereate a file called [admin-user-rbac.yaml](./assets/admin-user-rbac.yaml)

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kube-system
```

## Apply

Then a script called [setup-admin-user.sh](./assets/setup-admin-user.sh) to seth things up

```bash
kubectl apply -f admin-user-serviceaccount.yaml
kubectl apply -f admin-user-rbac.yaml
echo '- - - - - - - - - - - - - - - - - - - - - - - - - -'
kubectl get -n kube-system secret $(kubectl get -n kube-system sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}" | tee token.txt
echo
echo '- - - - - - - - - - - - - - - - - - - - - - - - - -'
kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user admin-user
```

## Kubernetes Dashboard

To get the Kubernetes dashboard and proxy to it, run this script [dashboard-and-proxy.sh](./assets/dashboard-and-proxy.sh)

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml
kubectl proxy
```