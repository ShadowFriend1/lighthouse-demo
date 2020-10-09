install_namespace=lighthouse

kubectl -n $install_namespace get cm config -o yaml
kubectl -n $install_namespace get cm plugins -o yaml