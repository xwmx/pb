#!/usr/bin/env bash
#            __
#     ____  / /_
#    / __ \/ __ \
#   / /_/ / /_/ /
#  / .___/_.___/
# /_/
#
# A simple wrapper combining pbcopy & pbpaste in a single command.
#
# Based on Bash Boilerplate: https://github.com/alphabetum/bash-boilerplate
#
# Copyright (c) 2015 William Melody • hi@williammelody.com

set -o nounset
set -o errexit
set -o pipefail
IFS=$'\n\t'

###############################################################################
# Dependency / Platform Check
###############################################################################

# command_exists()
#
# Usage:
#   command_exists "command_name"
#
# Returns:
#   0  If the command exists in the current environment.
#   1  If not.
command_exists() {
  hash "$1" 2>/dev/null
}

if ! command_exists "pbcopy"
then
  printf "pbcopy not found on this system.\n"
  exit 1
elif ! command_exists "pbpaste"
then
  printf "pbpaste not found on this system.\n"
  exit 1
fi

###############################################################################
# Environment
###############################################################################

# $_ME
#
# Set to this program's basename.
_ME=$(basename "$0")

# $_VERSION
#
# Manually set this to to current version of the program.
_VERSION="1.0.1"

###############################################################################
# Help
###############################################################################

read -r -d '' "_program_help" <<EOM || true
           __
    ____  / /_
   / __ \/ __ \\
  / /_/ / /_/ /
 / .___/_.___/
/_/

A simple wrapper combining pbcopy & pbpaste in a single command.

Version: $_VERSION

Usage:
  $_ME [-pboard {general | ruler | find | font}] [-Prefer {txt | rtf | ps}]
  $_ME <input> [-pboard {general | ruler | find | font}]
  $_ME --version
  $_ME -h | --help

Options:
  -pboard    Specify the pasteboard to copy to or paste from.
             Default: general
  -Prefer    Specify what type of data to look for in the pasteboard first.
  --version  Print the current program version.
  -h --help  Show this screen.

More information:
  Run \`man pbcopy\` or \`man pbpaste\`.
EOM

# _print_help()
#
# Usage: _print_help
#
# Print the program help information.
_print_help() {
  printf "%s\n" "$_program_help"
}

# _print_version()
#
# Usage: _print_help
#
# Print the current program version.
_print_version() {
  printf "%s\n" "$_VERSION"
}

###############################################################################
# Program Functions
###############################################################################

# _interactive_input()
#
# Usage:
#   _interactive_input
#
# Returns:
#   0  If the current input is interactive (eg, a shell).
#   1  If the current input is stdin / piped input.
_interactive_input() {
  [[ -t 0 ]]
}

# _pb()
#
# Usage:
#   _pb
#   _pb <arguments>
#   <command> | _pb
#
# Description:
#   Copy to or paste from the OS X clipboard/pasteboard. With no input, `pb`
#   prints the current contents of the clipboard to stdout using the `pbpaste`
#   command. When input is passed via stdin or an argument, `pb` acts as a
#   wrapper for `pbcopy`, which in the simplest case means that it replaces the
#   clipboard contents with the input.
_pb() {
  if _interactive_input
  then
    if [[ -n "${1:-}" ]] && [[ ! "${1:-}" =~ ^-.* ]]
    then
      local _input="$1"
      local _options=(${@:1})
      printf "%s" "$_input" | pbcopy "${_options:-}"
    else
      pbpaste "$@"
    fi
  else
    cat | pbcopy "$@"
  fi
}

###############################################################################
# Main
###############################################################################

# _main()
#
# Usage:
#   _main [<options>] [<arguments>]
#
# Description:
#   Entry point for the program, handling basic option parsing and dispatching.
_main() {
  case "${1:-}" in
    -h|--help)  _print_help     ;;
    --version)  _print_version  ;;
    *)          _pb "$@"        ;;
  esac
}

# Call `_main` after everything has been defined.
_main "$@"
