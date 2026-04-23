#!/usr/bin/env bash

set -euo pipefail

BASE_URL="${DOCKER_MIRROR_BASE_URL:-https://docker.aityp.com}"
API_BASE="${BASE_URL%/}/api/v1"

usage() {
  cat <<'EOF'
Usage:
  docker_mirror_api.sh website
  docker_mirror_api.sh health
  docker_mirror_api.sh latest
  docker_mirror_api.sh today
  docker_mirror_api.sh wait
  docker_mirror_api.sh error
  docker_mirror_api.sh image <search> [site] [platform]
  docker_mirror_api.sh email <address>
  docker_mirror_api.sh ip

Environment:
  DOCKER_MIRROR_BASE_URL  Override the default site base URL
EOF
}

die() {
  echo "docker_mirror_api.sh: $*" >&2
  exit 1
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "required command not found: $1"
}

urlencode() {
  local input="${1-}"
  local i char out=""
  for ((i = 0; i < ${#input}; i++)); do
    char="${input:i:1}"
    case "$char" in
      [a-zA-Z0-9.~_-]) out+="$char" ;;
      *) printf -v out '%s%%%02X' "$out" "'$char" ;;
    esac
  done
  printf '%s\n' "$out"
}

fetch() {
  local path="$1"
  curl --silent --show-error --fail --location \
    --connect-timeout 10 \
    --retry 2 \
    "${API_BASE}${path}"
}

main() {
  need_cmd curl

  local cmd="${1-}"
  [[ -n "$cmd" ]] || {
    usage
    exit 1
  }
  shift || true

  case "$cmd" in
    help|-h|--help)
      usage
      ;;
    website|health|latest|today|wait|error|ip)
      [[ $# -eq 0 ]] || die "'$cmd' does not accept extra arguments"
      fetch "/${cmd}"
      ;;
    email)
      [[ $# -eq 1 ]] || die "email requires exactly 1 argument: <address>"
      fetch "/email/$(urlencode "$1")"
      ;;
    image)
      [[ $# -ge 1 && $# -le 3 ]] || die "image requires <search> [site] [platform]"
      local search="$1"
      local site="${2-}"
      local platform="${3-}"
      local query="?search=$(urlencode "$search")"
      if [[ -n "$site" ]]; then
        query="${query}&site=$(urlencode "$site")"
      fi
      if [[ -n "$platform" ]]; then
        query="${query}&platform=$(urlencode "$platform")"
      fi
      fetch "/image${query}"
      ;;
    *)
      die "unknown subcommand: $cmd"
      ;;
  esac
}

main "$@"
