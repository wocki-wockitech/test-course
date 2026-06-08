#!/usr/bin/env bash
# Prepares the student's workspace at /workspace before the terminal opens.
# Runs as the sandbox user. Network is available.

set -euo pipefail

cd /workspace

git init -q
git config user.email "student@studyme.local"
git config user.name  "Student"

# Initial commit on main
echo "line one" > file.txt
git add file.txt
git commit -q -m "initial commit"

# Branch with a conflicting change
git checkout -q -b feature
echo "line one (feature)" > file.txt
git commit -q -am "edit on feature"

# Conflicting change on main
git checkout -q main
echo "line one (main)" > file.txt
git commit -q -am "edit on main"

# Trigger the conflict
if git merge feature -m "merge"; then
    echo "ERROR: expected a merge conflict but merge succeeded" >&2
    exit 1
fi

cat <<'EOF'
==============================================================
Workspace ready at /workspace.

Your task:
  1. Resolve the conflict in file.txt
  2. Final content of file.txt should be exactly:
       line one (resolved)
  3. Stage and commit the resolution

When you're done, click "Check" — the verifier will run check.sh.
==============================================================
EOF
