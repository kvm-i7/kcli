#!/bin/sh
set -e
BASE_URL="https://platform.kvm-i7.host/api"
CONFIG_FILE="$HOME/.kcli.conf"
usage() {
  cat << EOF
kcli - A simple CLI for the KVM-i7 API.

Usage:
  kcli <command> [arguments]

Setup:
  set-token <your-token>   Saves your API token to $CONFIG_FILE.

Commands:
  start                    Start the VPS.
  stop                     Stop the VPS.
  status                   Get the current power status.
  hardware                 Fetch hardware information.
  usage                    Fetch current resource usage.
  ssh-info                 Fetch SSH connection info.
  exec <"command">         Execute a command on the VPS.
  reinstall <template>     Reinstall the VPS using an OS template string.
  reinstall-options        List available OS templates.
  help                     Show this help message.

Example:
  kcli exec "uname -a"
  kcli reinstall "local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
EOF
}
_api_get() {
  curl -s -X GET \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    "$BASE_URL/$1"
}
_api_post() {
  curl -s -X POST \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "$2" \
    "$BASE_URL/$1"
}
_process() {
  RESP=$(cat)
  if ! echo "$RESP" | jq . > /dev/null 2>&1; then
    echo "Error: Invalid API response." >&2
    echo "Raw Response: $RESP" >&2
    exit 1
  fi
  echo "$RESP" | jq .
}
if [ $# -gt 0 ]; then
  CMD="$1"
  shift
else
  CMD="help"
fi
case "$CMD" in
  help|-h|--help)
    usage
    exit 0
    ;;
  set-token)
    if [ -z "$1" ]; then
      echo "Error: Token argument is missing." >&2
      echo "Usage: kcli set-token <your-token>" >&2
      exit 1
    fi
    echo "$1" > "$CONFIG_FILE"
    chmod 600 "$CONFIG_FILE"
    echo "Token saved to $CONFIG_FILE."
    exit 0
    ;;
esac
if ! command -v curl >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
  echo "Error: 'curl' and 'jq' are required." >&2
  exit 1
fi
if [ -n "$KVM_I7_TOKEN" ]; then
  TOKEN="$KVM_I7_TOKEN"
elif [ -f "$CONFIG_FILE" ]; then
  TOKEN=$(cat "$CONFIG_FILE")
else
  echo "Error: API Token not found." >&2
  echo "Run 'kcli set-token <your-token>' to configure." >&2
  exit 1
fi
case "$CMD" in
  start|stop|status)
    _api_get "$CMD" | _process
    ;;
  hardware)
    _api_get "fetch-hardware" | _process
    ;;
  usage)
    _api_get "fetch-usage" | _process
    ;;
  ssh-info)
    _api_get "sshinfo" | _process
    ;;
  reinstall-options)
    _api_get "reinstall/options" | _process
    ;;
  exec)
    if [ $# -eq 0 ]; then echo "Error: Missing command for 'exec'." >&2; exit 1; fi
    DATA=$(jq -n --arg cmd "$*" '{"command": $cmd}')
    _api_post "exec" "$DATA" | _process
    ;;
  reinstall)
    if [ $# -eq 0 ]; then echo "Error: Missing OS template for 'reinstall'." >&2; exit 1; fi
    DATA=$(jq -n --arg os "$1" '{"os_template": $1}')
    _api_post "reinstall" "$DATA" | _process
    ;;
  *)
    echo "Error: Unknown command '$CMD'" >&2
    usage
    exit 1
    ;;
esac
