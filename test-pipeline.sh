# Github repository name
repo_name=hello
install_namespace=lighthouse

cat <<EOF | kubectl apply -f -
apiVersion: tekton.dev/v1beta1
kind: PipelineRun
metadata:
  name: ${repo_name}-pipeline-run
  namespace: ${install_namespace}
spec:
  serviceAccountName: app-builder
  pipelineRef:
    name: ${repo_name}-pipeline
  workspaces:
    - name: shared-workspace
      persistentvolumeclaim:
        claimName: buildpacks-source-pvc
  resources:
    - name: build-image
      resourceRef:
        name: buildpacks-app-image
  podTemplate:
    volumes:
      - name: buildpacks-cache
        persistentVolumeClaim:
          claimName: buildpacks-cache-pvc
EOF