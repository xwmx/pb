#!/usr/bin/env bash
###############################################################################
#            __
#     ____  / /_
#    / __ \/ __ \
#   / /_/ / /_/ /
#  / .___/_.___/
# /_/
#
# A simple wrapper combining pbcopy & pbpaste in a single command.
#
# https://github.com/xwmx/pb
#
# Based on Bash Boilerplate: https://github.com/xwmx/bash-boilerplate
#
# The MIT License (MIT)
#
# Copyright (c) 2015 William Melody • hi@williammelody.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
###############################################################################

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
_command_exists() {
  hash "${1}" 2>/dev/null
}

if ! _command_exists "pbcopy"
then
  printf "pbcopy not found on this system.\n"
  exit 1
elif ! _command_exists "pbpaste"
then
  printf "pbpaste not found on this system.\n"
  exit 1
fi

###############################################################################
# Utility Functions
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

###############################################################################
# Environment
###############################################################################

# $_ME
#
# Set to this program's basename.
_ME=$(basename "${0}")

# $_VERSION
#
# Manually set this to to current version of the program.
_VERSION="1.3.2"

###############################################################################
# Help
###############################################################################

# _print_help()
#
# Usage: _print_help
#
# Print the program help information.
_print_help() {
  {
    cat <<HEREDOC
           __
    ____  / /_
   / __ \/ __ \\
  / /_/ / /_/ /
 / .___/_.___/
/_/

A simple wrapper combining pbcopy & pbpaste in a single command.

Usage:
  ${_ME} [-pboard {general | ruler | find | font}] [-Prefer {txt | rtf | ps}]
     [-p | --preview]
  ${_ME} <input> [-pboard {general | ruler | find | font}]
  ${_ME} --clear
  ${_ME} --version
  ${_ME} -h | --help

Options:
  --clear        Clear the contents of all pasteboards.
  -pboard        Specify the pasteboard to copy to or paste from.
                 Default: general
  -Prefer        Specify what type of data to look for in the pasteboard first.
  -p, --preview  Display pasteboard content in \$PAGER, or \`less\` if unset.
  --version      Print the current program version.
  -h --help      Show this screen.

Examples:
  pb "Example text."         Copy data specied with an argument.
  echo "Example text." | pb  Copy piped data.
  pb                         Print contents of the clipboard / pasteboard.
  pb -pboard find            Print contents of the "find" pasteboard.
  pb --preview               Display the contents of the pasteboard in a pager.

More information:
  Run \`man pbcopy\` or \`man pbpaste\`.

Home:
  https://github.com/xwmx/pb
HEREDOC
  } | {
    if [[ -n "${PAGER:-}" ]] && [[ ! "${PAGER:-}" =~ ^less ]]
    then
      "${PAGER:-}"
    else
      less -F
    fi
  }
}

# _print_version()
#
# Usage: _print_help
#
# Print the current program version.
_print_version() {
  printf "%s\n" "${_VERSION}"
}

###############################################################################
# Program Functions
###############################################################################

# _clear_pasteboards()
#
# Usage:
#   _clear_pasteboards
#
# Description:
#   Erase the contents of each clipboard.
_clear_pasteboards() {
  for __pasteboard in "general" "ruler" "find" "font"
  do
    printf "" | pbcopy -pboard "${__pasteboard}"
  done

  printf "Pasteboards / Clipboard cleared.\\n" 1>&2
}

# _preview()
#
# Usage:
#   _preview
#
# Description:
#   Display a preview of the clipboard/pasteboard contents in PAGER.
_preview() {
  _pb | "${PAGER:-less}"
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
  local _input=
  local _options=()
  local _preview=0

  while ((${#}))
  do
    case "${1:-}" in
      -clear|--clear)
        _clear_pasteboards

        exit 0
        ;;
      -h|-help|--help)
        _print_help

        exit 0
        ;;
      -pboard|--pboard|-Prefer|--Prefer|-prefer|--prefer)
        if [[ -n "${2:-}" ]]
        then
          _options+=("${1}" "${2}")

          shift
        else
          _input="${_input:-}${1:-}"
        fi
        ;;
      -p|--preview)
        _preview=1
        ;;
      -version|--version)
        _print_version

        exit 0
        ;;
      *)
        _input="${1:-}"
        ;;
    esac

    shift
  done

  if _interactive_input
  then
    if [[ -n "${_input:-}" ]]
    then
      printf "%s" "${_input}" | pbcopy "${_options[@]:-}"
    else
      {
        pbpaste "${_options[@]:-}"
      } | {
        if ((_preview))
        then
          cat | "${PAGER:-less}"
        else
          cat
        fi
      }
    fi
  else
    cat | pbcopy "${_options[@]:-}"
  fi
}

_pb "${@:-}"
