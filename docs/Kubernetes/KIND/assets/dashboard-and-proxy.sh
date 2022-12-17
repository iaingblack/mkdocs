kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml
echo '- - - - - - - - - - - - - - - - - - - - - - - - - -'
kubectl get -n kube-system secret $(kubectl get -n kube-system sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}" | tee token.txt
echo
echo '- - - - - - - - - - - - - - - - - - - - - - - - - -'
kubectl proxy