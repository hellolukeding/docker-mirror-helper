#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_SCRIPT="${ROOT_DIR}/docker-mirror-helper/scripts/docker_mirror_api.sh"

echo "==> Checking shell syntax"
bash -n "${SKILL_SCRIPT}"
bash -n "${ROOT_DIR}/scripts/validate.sh"

echo "==> Running smoke tests"
bash "${SKILL_SCRIPT}" health >/dev/null
bash "${SKILL_SCRIPT}" website >/dev/null
bash "${SKILL_SCRIPT}" image 'python:3.12-slim' docker.io linux/amd64 >/dev/null

echo "Validation passed."
