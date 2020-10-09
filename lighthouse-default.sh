# Github Username for bot/organisation account
bot_user=<>
repo_name=lighthouse-config
# Github Username for approver account
approver=<>
# Github token for bot/organisation account
GITHUB_TOKEN=<>

mkdir $repo_name
cd $repo_name
git init

cat > config.yaml <<EOF
pod_namespace: lighthouse
prowjob_namespace: lighthouse
tide:
  queries:
  - labels:
    - approved
    repos:
    - $bot_user/$repo_name
EOF

cat > plugins.yaml <<EOF
approve:
- lgtm_acts_as_approve: false
  repos:
  - $bot_user/$repo_name
  require_self_approval: true
config_updater:
  gzip: false
  maps:
    config.yaml:
      name: config
    plugins.yaml:
      name: plugins  
plugins:
  $bot_user/$repo_name:
  - config-updater
  - approve
  - lgtm  
EOF

cat > OWNERS <<EOF
approvers:
- $approver
reviewers:
- $approver
EOF

git add .
git commit -m "Initial Lighthouse config"

gh repo create $repo_name --public -y
gh api -X PUT repos/$bot_user/$repo_name/collaborators/$approver
git remote add origin https://github.com/test1612/lighthouse-config.git
git push origin master