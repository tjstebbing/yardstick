DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Aliases
alias jsonresp="$DIR/http2json/http2json" 

info()  { $VERBOSE && echo "[INFO ${FUNCNAME[1]}] ${@}"; }
iinfo()  { $VERBOSE && echo "[INFO ${FUNCNAME[2]}] ${@}"; }
warn()  { $VERBOSE && echo "[WARN ${FUNCNAME[1]}] ${@}"; }
err()   { $VERBOSE && echo "[ERRO ${FUNCNAME[1]}] ${@}"; }

# loads all scripts passed in, ie:  RunTests ./test_*   would get all test_* files
# once loaded it then sources shunit2 which runs all test functions
#. "$DIR/shunit2"
__yard_run() {
	# run shunit
  echo "RUNNING $1"
  "/bin/bash $DIR/shunit2 $1"
}

yard() {
 echo "not implemented yet"
}
