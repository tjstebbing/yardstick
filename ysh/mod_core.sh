export mod_core=true

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

info()  { $VERBOSE && echo "[INFO ${FUNCNAME[1]}] ${@}"; }
iinfo()  { $VERBOSE && echo "[INFO ${FUNCNAME[2]}] ${@}"; }
warn()  { $VERBOSE && echo "[WARN ${FUNCNAME[1]}] ${@}"; }
err()   { $VERBOSE && echo "[ERRO ${FUNCNAME[1]}] ${@}"; }

__depends() {
  return 0
}

__die() {
  err "$1"
  exit 1
}

__isfunc() {
  declare -f "$1" > /dev/null; 
  if [[ $? -eq 0 ]]; then
    echo true
  else
    echo false
  fi
}

yard() {
  local cmd args mvar
  cmd=$1
  args=("$@")

  case $cmd in
    'module')
      # module loading, usage: yard module module1, module2
      for mod in "${args[@]:1}"
      do
        mvar="mod_$mod"
        if [ -z "${!mvar}" ]; then
          :
        else
          continue
        fi
        if [[ -r "$DIR/mod_$mod.sh" ]]; 
        then
          . "$DIR/mod_$mod.sh"
        else
          err "Cannot load module $mod"
          exit 1
        fi
      done
      ;;
    *)
      if [[ $(__isfunc "yard_$cmd") == true ]]; then
        "yard_$cmd" "${args[@]:1}"
      else
        __die "yard: sub-command not found '$cmd'"
      fi
  esac
}

yard_test() {
  $1
  echo $?
}

assert() {

  if [[ $#  == 0 ]]; then
    # nothing to test, exit
    return 0
  fi

  # assert equal
  if [ $# -eq 3 -o $# -eq 4 ] && [ "$2" == 'equals' ]; then
    __assertEquals "$1" "$3" "$4" 
    return $?
  fi

  # assert not equal
  if [ $# -eq 4 -o $# -eq 5 ] && [ "$2" == 'not' -a "$3" == 'equals' ]; then
    __assertNotEquals "$1" "$4" "$5"  
    return $?
  fi

  # assert null
  if [ $# -eq 2 -o $# -eq 3 ] && [ "$2" == 'null' ]; then
    __assertNull "$1" "$3" 
    return $?
  fi

  #assert not null
  if [ $# -eq 3 -o $# -eq 4 ] && [ "$2" == 'not' -a "$3" == 'null' ]; then
    __assertNotNull "$1" "$4"  
    return $?
  fi

  # assert
  if [[ $# -lt 3 ]]; then
    __assertTrue "$1" "$2" 
    return $?
  fi

  __fail "malformed assertion. $# $*"
}

__assertNull() {
  local val desc
  val=$1
  desc=$2
  if [ -z "$val" ]; then
    return 0
  fi
  __fail "'$val' is not null." "$desc" 
  return 1
}

__assertNotNull() {
  local val desc
  val=$1
  desc=$2
  if [ -z "$val" ]; then
    __fail "'$val' is null." "$desc" 
    return 1
  fi
  return 0
}

__assertEquals() {
  local val val2 desc
  val=$1
  val2=$2
  desc=$3
  if [ "$val" == "$val2" ]; then
    return 0
  fi
  __fail "'$val' is not equal to '$val2'." "$desc" 
  return 1
}

__assertNotEquals() {
  local val val2 desc
  val=$1
  val2=$2
  desc=$3
  if [ "$val" != "$val2" ]; then
    return 0
  fi
  __fail "'$val' is equal to '$val2'." "$desc" 
  return 1
}

__assertTrue() {
  local val desc
  val=$1
  desc=$2
  if [ "$val" == true -o "$val" == 0 ]; then
    return 0
  fi
  __fail "'$val' is not true." "$desc" 
  return 1
}

__contains() {
  local e; for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done; return 1
}

__fail() {
  local fDepth sDepth f l
  fDepth=${#BASH_SOURCE[*]}
  sDepth=${#BASH_LINENO[*]}
  fDepth=$(( fDepth - 3 ))
  sDepth=$(( sDepth - 4 ))
  f=${BASH_SOURCE[fDepth]}
  l=${BASH_LINENO[sDepth]}
  __test_status=1
  __test_message="$__test_message\n[$f:$l]: $1"
  if [[ "$2" ]]; then
    __test_message="$__test_message ($2)"
  fi
}

main() {
  local run failed start stop duration funcRegex
  declare -a processed
  run=0
  failed=0
  for file in "$@"; do
    source "$file"
    # regex from shunit2, tyvm
    funcRegex='^\s*((function test[A-Za-z0-9_-]*)|(test[A-Za-z0-9_-]* *\(\)))'
    for t in $(grep -E "${funcRegex}" "${file}" | sed 's/^[^A-Za-z0-9_-]*//;s/^function //;s/\([A-Za-z0-9_-]*\).*/\1/g' | xargs); do
      if ! __contains "$t" "${processed[@]}"; then
        unset __test_status __test_message 
        echo "=== RUN $t"
        start="$SECONDS"
        $t
        __test_status=${__test_status:-$?}
        stop="$SECONDS"
        duration=$((stop-start))
        processed+=("$t")
        run=$((run+1))
        if [[ "$__test_status" == 0 ]]; then
          echo "--- PASS $t (${duration}s)"
        else
          failed=$((failed+1))
          echo "--- FAIL $t (${duration}s)"
          if [[ "$__test_message" ]]; then
            printf "    $__test_message"
            echo
          fi
        fi
      fi
    done
  done
  echo
  if [[ "$failed" == "0" ]]; then
    echo "Ran $run tests."
    echo
    echo "PASS"
  else
    echo "Ran $run tests. $failed failed."
    echo
    echo "FAIL"
    exit $failed
  fi
}
