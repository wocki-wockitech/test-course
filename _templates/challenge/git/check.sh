#!/usr/bin/env bash
# Validates the student's work.
# Exit 0  = pass
# Exit !=0 = fail (stdout/stderr shown to the student)

set -euo pipefail
cd /workspace

# Working tree must be clean (everything committed)
if [[ -n "$(git status --porcelain)" ]]; then
    echo "FAIL: there are uncommitted changes. Run 'git add' and 'git commit'." >&2
    exit 1
fi

# Merge must be completed (no MERGE_HEAD)
if [[ -f .git/MERGE_HEAD ]]; then
    echo "FAIL: merge is still in progress. Commit the resolution." >&2
    exit 1
fi

# File contents must match exactly
expected="line one (resolved)"
actual="$(cat file.txt)"

if [[ "$actual" != "$expected" ]]; then
    echo "FAIL: file.txt does not match the expected content." >&2
    echo "Expected:" >&2
    echo "  $expected" >&2
    echo "Got:" >&2
    echo "  $actual" >&2
    exit 1
fi

echo "PASS: conflict resolved correctly."
