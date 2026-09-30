# shellcheck shell=bash
#
# logger.sh: colored logging helpers. Meant to be sourced, not executed.
#
# Provides: log_step, log_info, log_ok, log_warning, log_error, confirm.
# Colors are disabled when stdout isn't a terminal, NO_COLOR is set,
# or tput can't handle the current terminal.

# Guard against being sourced twice (the color variables are readonly).
if [[ -n ${_LOGGER_LOADED:-} ]]; then
  return 0
fi
_LOGGER_LOADED=1

if [[ -t 1 && -z ${NO_COLOR:-} ]] && tput setaf 1 &>/dev/null; then
  RESET=$(tput sgr0)
  BOLD=$(tput bold)
  RED=$(tput setaf 1)
  GREEN=$(tput setaf 2)
  YELLOW=$(tput setaf 3)
  BLUE=$(tput setaf 4)
  CYAN=$(tput setaf 6)
else
  RESET="" BOLD="" RED="" GREEN="" YELLOW="" BLUE="" CYAN=""
fi
readonly RESET BOLD RED GREEN YELLOW BLUE CYAN

# _log <style> <message>...
_log() {
  local style=$1
  shift
  printf '%s%s%s\n' "$style" "$*" "$RESET"
}

log_step() {
  printf '%s===>%s %s%s%s\n' "$CYAN$BOLD" "$RESET" "$BOLD" "$*" "$RESET"
}

log_info() { _log "$BLUE$BOLD" "$@"; }
log_ok() { _log "$GREEN" "$@"; }
log_warning() { _log "$YELLOW" "$@"; }
log_error() { _log "$RED" "$@" >&2; }

# confirm [prompt]
# Succeeds only if the user types exactly "yes".
confirm() {
  local reply
  read -rp "$YELLOW$BOLD${1:-Type 'yes' to continue:}$RESET " reply
  [[ $reply == "yes" ]]
}
