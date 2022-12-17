kubectl apply -f admin-user-serviceaccount.yaml
kubectl apply -f admin-user-rbac.yaml
echo '- - - - - - - - - - - - - - - - - - - - - - - - - -'
kubectl get -n kube-system secret $(kubectl get -n kube-system sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}" | tee token.txt
echo
echo '- - - - - - - - - - - - - - - - - - - - - - - - - -'
# Rancher User
kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user admin-user