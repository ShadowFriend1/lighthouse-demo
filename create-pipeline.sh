# Docker Username for hosting account
docker_user=<>
# Dockerhub image name
image_name=<>
# Github Username for bot/organisation account
repo_owner=<>
# Github repository name
repo_name=hello
install_namespace=lighthouse

cat <<EOF | kubectl apply -n ${install_namespace} -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: app-builder
secrets:
  - name: github
  - name: dockerhub
---
apiVersion: tekton.dev/v1alpha1
kind: PipelineResource
metadata:
  name: buildpacks-app-image
spec:
  type: image
  params:
    - name: url
      value: ${docker_user}/${image_name}:latest
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: buildpacks-source-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 500Mi
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: buildpacks-cache-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 500Mi
---
apiVersion: tekton.dev/v1beta1
kind: Pipeline
metadata:
  name: ${repo_name}-pipeline
spec:
  workspaces:
    - name: shared-workspace
  resources:
    - name: build-image
      type: image
  tasks:
    - name: fetch-repository
      taskRef:
        name: git-clone
      workspaces:
        - name: output
          workspace: shared-workspace
      params:
        - name: url
          value: https://github.com/$repo_owner/$repo_name
        - name: deleteExisting
          value: "true"
    - name: buildpacks
      taskRef:
        name: buildpacks
      runAfter:
        - fetch-repository
      workspaces:
        - name: source
          workspace: shared-workspace
      params:
        - name: BUILDER_IMAGE
          value: paketobuildpacks/builder:tiny
        - name: CACHE
          value: buildpacks-cache
      resources:
        outputs:
          - name: image
            resource: build-image
EOF