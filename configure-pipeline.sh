# Github Username for bot/organisation account
github_user=<>
# Github Password for bot/organisation account
github_pass=<>
# Docker Username for hosting account
docker_user=<>
# Docker Password for hosting account
docker_pass=<>

install_namespace=lighthouse

cat <<EOF | kubectl apply -n ${install_namespace} -f -
apiVersion: v1
kind: Secret
metadata:
  name: dockerhub
  annotations: 
    tekton.dev/docker-0: https://index.docker.io/v1/
type: kubernetes.io/basic-auth
stringData:
  username: $docker_user
  password: $docker_pass
EOF

cat <<EOF | kubectl apply -n ${install_namespace} -f -
apiVersion: v1
kind: Secret
metadata:
  name: github
  annotations:
    tekton.dev/git-0: https://github.com
type: kubernetes.io/basic-auth
stringData:
  username: $github_user
  password: $github_pass
EOF

kubectl apply -n $install_namespace -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/git-clone/0.2/git-clone.yaml
kubectl apply -n $install_namespace -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/buildpacks/0.1/buildpacks.yaml