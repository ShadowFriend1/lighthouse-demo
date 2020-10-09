Tekton lighthouse demo:
Installation drawn from https://github.com/jenkins-x/lighthouse/blob/master/docs/install_lighthouse_with_tekton.md#objective

Installation:
Pregrequisites are a kubernetes cluster (I used minikube) with ingress controller enabled (e.g. NGINX), pack, tekton pipelines installed on the cluster and optionally tekton dashboard, an organization or bot account for  github (and an OAuth token for this user) and another account to act as approver, and a generated secret for webhook delivery (can be created with "$ruby -rsecurerandom -e 'puts SecureRandom.hex(42)'").

Fill in the variable in the .sh scripts.

execute the shell scripts in the following order:

lighthouse-default.sh - Creates lighthouse-config files and pushes to repository (may need to be run twice, once to instate repository and another time once the approver has accepted the invite to collaborate on the project).

kube-namespace.sh - Creates the configmap to config.yaml and plugins.yaml and adds the lighthouse helm repository.

lighthouse-helm-install.sh - Installs lighthouse using helm.

Optional - check-webhook.sh - checks that events in the configuration repository propagate to lighthouse via webhook.

test-project.sh - Creates a test project (hello world server in go) and propagates it to github (may need to be run twice, once to instate repository and another time once the approver has accepted the invite to collaborate on the project).

config-pipeline.sh - Configures pipeline secrets.

create-pipeline.sh - Creates tekton pipeline.

Optional - test-pipeline.sh - Creates a PipelineRun against the created pipeline to check that it builds correctly.

update-config-plugins.sh - Updates the config.yaml and plugins.yaml to contain a postsubmit and creates a pull request against master in the lighthouse-config repository (which creates a webhook to trigger an update in the lighthouse configmap).

create-webhook.sh - Creates a webhook to lighthouse from the project repository.

The webhooks created by the shell scripts dont have URLs configured correctly so these must be manaually corrected in the repositories to target your server.