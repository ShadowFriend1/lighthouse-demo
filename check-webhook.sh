# Github token for bot/organisation account
GITHUB_TOKEN=<>

install_namespace=lighthouse
# Github Username for bot/organisation account
bot_user=<>
# Name of repository for lighthouse configuration files
repo_name=lighthouse-config
webhook_url=$(kubectl get ingress -n $install_namespace -o=jsonpath='http://{.items[0].spec.rules[0].host}'/hook)
# Generated secret for the github webhook
webhook_secret=<>

cat <<EOF | gh api -X POST repos/$bot_user/$repo_name/hooks --input -
{
  "name": "web",
  "active": true,
  "events": [
    "*"
  ],
  "config": {
    "url": "$webhook_url",
    "content_type": "json",
    "insecure_ssl": "0",
    "secret": "$webhook_secret"
  }
}
EOF