# Github Username for bot/organisation account
bot_user=<>
# Github repository name
repo_name=hello
# Github Username for approver account
approver=<>
# Github token for bot/organisation account
GITHUB_TOKEN=<>

mkdir $repo_name
cd $repo_name
git init

cat > main.go <<EOF
package main

import (
    "fmt"
    "net/http"
)

func main() {
    http.HandleFunc("/", HelloServer)
    http.ListenAndServe(":8080", nil)
}

func HelloServer(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello, %s!", r.URL.Path[1:])
}
EOF

cat > OWNERS <<EOF
approvers:
- $approver
reviewers:
- $approver
EOF

git add .
git commit -m "Initial import"

gh repo create $repo_name --public -y
gh api -X PUT repos/$bot_user/$repo_name/collaborators/$approver
git push origin master