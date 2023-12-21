#!/usr/bin/env bash

set -euo pipefail

# Required inputs.
if [[ -z ${JUNIT_PATHS} ]]; then
	echo "Missing junit files"
	exit 2
fi

if [[ -z ${ORG_URL_SLUG} ]]; then
	echo "Missing organization url slug"
	exit 2
fi

if [[ (-z ${INPUT_TOKEN}) && (-z ${TRUNK_API_TOKEN}) ]]; then
	echo "Missing trunk api token"
	exit 2
fi
TOKEN=${INPUT_TOKEN:-${TRUNK_API_TOKEN}} # Defaults to TRUNK_API_TOKEN env var. 

DRY_RUN=${INPUT_DRY_RUN:-false} # Defaults to false.

# CLI.
API_ADDRESS=${INPUT_API_ADDRESS:-"https://api.trunk.io:5022"}
API_URL=${API_ADDRESS}/ # TODO: add binary

curl -fsSL --retry 1 --retry-connrefused --connect-timeout 5 "${API_URL}" > ./trunk-analytics-uploader

./trunk-analytics-uploader upload --junit-paths ${JUNIT_PATHS} --org-url-slug ${ORG_URL_SLUG} --token ${TOKEN} --api-address ${API_ADDRESS} --repo-root ${REPO_ROOT} --repo-url ${REPO_URL} --repo-head-sha ${REPO_HEAD_SHA} --repo-head-branch ${REPO_HEAD_BRANCH} --repo-head-commit-epoch ${REPO_HEAD_COMMIT_EPOCH} --custom-tags ${CUSTOM_TAGS} --dry-run ${DRY_RUN}
