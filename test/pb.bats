#!/usr/bin/env bats

load test_helper

_HELP_HEADER="\
           __
    ____  / /_
   / __ \/ __ \\
  / /_/ / /_/ /
 / .___/_.___/
/_/"
export _HELP_HEADER

@test "\`pb -h\` prints default help." {
  run "${_PB}" -h
  _compare "${_HELP_HEADER}" $(IFS=$'\n'; echo "${lines[*]:0:6}")
  [[ $(IFS=$'\n'; echo "${lines[*]:0:6}") == "${_HELP_HEADER}" ]]
}

@test "\`pb --help\` prints default help." {
  run "${_PB}" --help
  _compare "${_HELP_HEADER}" $(IFS=$'\n'; echo "${lines[*]:0:6}")
  [[ $(IFS=$'\n'; echo "${lines[*]:0:6}") == "${_HELP_HEADER}" ]]
}

@test "\`pb --version\` returns with 0 status." {
  run "${_PB}" --version
  [[ "${status}" -eq 0 ]]
}

@test "\`pb --version\` prints a version number." {
  run "${_PB}" --version
  printf "'%s'" "${output}"
  echo "${output}" | grep -q '\d\+\.\d\+\.\d\+'
}

@test "\`pb\` returns with 0 status." {
  run "${_PB}"
  [[ "${status}" -eq 0 ]]
}

@test "\`pb <string>\` returns with 0 status." {
  run "${_PB}" "test string"
  [[ "${status}" -eq 0 ]]
}

@test "\`echo 'test string' | pb\` returns with 0 status." {
  run echo 'test string' | "${_PB}"
  [[ "${status}" -eq 0 ]]
}

@test "\`pb\` prints a string saved with \`pb <string>\`." {
  "${_PB}" "test string as argument"
  run "${_PB}"
  [[ "${output}" == "test string as argument" ]]
}

@test "\`pb\` prints a string saved with \`<string> pb\`." {
  echo "piped test string" | "${_PB}"
  run "${_PB}"
  _compare "piped test string" "${output}"
  [[ "${output}" == "piped test string" ]]
}
