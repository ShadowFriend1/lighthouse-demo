# Github Username for bot/organisation account
bot_user=<>
# Name of repository for lighthouse configuration files
config_repo_name=lighthouse-config
# Github repository name
sample_repo_name=hello
# Github token for bot/organisation account
GITHUB_TOKEN=<>

git checkout -b config-update
cat > config.yaml <<EOF
pod_namespace: lighthouse
prowjob_namespace: lighthouse
postsubmits:
  $bot_user/$sample_repo_name:
    - agent: tekton-pipeline
      branches:
        - master
      context: $sample_repo_name
      name: $sample_repo_name
      pipeline_run_spec:
        serviceAccountName: app-builder
        pipelineRef:
          name: ${sample_repo_name}-pipeline
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
tide:
  queries:
  - labels:
    - approved
    repos:
    - $bot_user/$config_repo_name
    - $bot_user/$sample_repo_name
EOF

cat > plugins.yaml <<EOF
approve:
- lgtm_acts_as_approve: false
  repos:
  - $bot_user/$config_repo_name
  - $bot_user/$sample_repo_name
  require_self_approval: true
config_updater:
  gzip: false
  maps:
    config.yaml:
      name: config
    plugins.yaml:
      name: plugins
triggers:
- repos:
  - $bot_user/$sample_repo_name
  ignore_ok_to_test: false
  elide_skipped_contexts: false
plugins:
  $bot_user/$config_repo_name:
  - config-updater
  - approve
  - lgtm  
  $bot_user/$sample_repo_name:
  - approve
  - lgtm
  - trigger
EOF

git commit -a -m "feat: adding bot_user/$sample_repo_name to Lighhouse config"
gh pr create --title "adding bot_user/$sample_repo_name to Lighhouse config" --body ""
gh pr view --web