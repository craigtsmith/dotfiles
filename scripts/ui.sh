#!/usr/bin/env bash
#
# UI helpers using gum for nice terminal output
#

# Check if gum is available (cached for performance)
_GUM_AVAILABLE=""
has_gum() {
  if [[ -z "$_GUM_AVAILABLE" ]]; then
    command -v gum >/dev/null 2>&1 && _GUM_AVAILABLE="yes" || _GUM_AVAILABLE="no"
  fi
  [[ "$_GUM_AVAILABLE" == "yes" ]]
}

# Print styled message with gum fallback
# Usage: _styled "color" "prefix" "message"
_styled() {
  local color="$1" prefix="$2" message="$3"
  if has_gum; then
    gum style --foreground "$color" "$prefix $message"
  else
    printf "%s %s\n" "$prefix" "$message"
  fi
}

# Spinner that runs a command
# Usage: spin "label" command args...
spin() {
  local label="$1"
  shift
  if has_gum; then
    gum spin --spinner dot --title "$label" -- "$@"
    tick "$label"
  else
    printf "  %s... " "$label"
    if "$@" >/dev/null 2>&1; then
      printf "done\n"
    else
      printf "failed\n"
      return 1
    fi
  fi
}

tick()  { _styled 10 "✅" "$1"; }
info()  { [[ "$VERBOSE" == "true" ]] && _styled 12 "ℹ" "$1" || true; }
warn()  { _styled 11 "⚠" "$1"; }
error() { has_gum && _styled 9 "✗" "$1" || printf "✗ %s\n" "$1" >&2; }

# Print final status
# Usage: done_message
done_message() {
  if [[ "$CHANGES_MADE" == "true" ]]; then
    echo ""
    tick "dotfiles installed successfully"
  else
    tick "dotfiles are up to date"
  fi
}
