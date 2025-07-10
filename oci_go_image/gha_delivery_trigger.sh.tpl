#!/usr/bin/env bash
set -o pipefail -o errexit -o nounset

echo "Triggering delivery of ${ASPECT_WORKFLOWS_DELIVERY_TARGET}"
echo "Repository: ${ASPECT_WORKFLOWS_DELIVERY_REPOSITORY}"
echo "Workflow: ${ASPECT_WORKFLOWS_DELIVERY_WORKFLOW}"
echo "Ref: ${GITHUB_REF_NAME_ENV}"
echo "Commit: ${GITHUB_SHA_ENV}"

curl -X POST \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token ${GITHUB_TOKEN_ENV}" \
    https://api.github.com/repos/${ASPECT_WORKFLOWS_DELIVERY_REPOSITORY}/actions/workflows/${ASPECT_WORKFLOWS_DELIVERY_WORKFLOW}/dispatches \
    -d "{\"ref\":\"${GITHUB_REF_NAME_ENV}\",\"inputs\":{\"delivery_commit\":\"${GITHUB_SHA_ENV}\",\"delivery_targets\":\"${ASPECT_WORKFLOWS_DELIVERY_TARGET}\"}}"
