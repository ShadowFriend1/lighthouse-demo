install_namespace=lighthouse
# Github Username for bot/organisation account
bot_user=<>
# Github token for bot/organisation account
bot_token=<>
# Generated secret for the github webhook
webhook_secret=<>
tekton_dash_url=http://<>/api/v1/namespaces/tekton-pipelines/services/tekton-dashboard:http/proxy/
# Kubernetes domain for lighthouse installation
domain=<>

helm install lighthouse lighthouse/lighthouse -n ${install_namespace} -f <(cat <<EOF
git:
  kind: github
  name: github
  server: https://github.com

user: "${bot_user}"
oauthToken: "${bot_token}"
hmacToken: "${webhook_secret}"

cluster:
  crds:
    create: true

tektoncontroller:
  dashboardURL: $tekton_dash_url

engines:
  jx: false
  tekton: true

configMaps:
  create: true

webhooks:
  ingress:
    enabled: true
    annotations:
      kubernetes.io/ingress.class: "nginx"
    hosts:
    - "$install_namespace.$domain"
EOF
)