install_namespace=lighthouse

kubectl create namespace $install_namespace
kubectl create cm config -n $install_namespace --from-file=config.yaml
kubectl create cm plugins -n $install_namespace --from-file=plugins.yaml

helm repo add lighthouse http://chartmuseum.jenkins-x.io
helm repo update