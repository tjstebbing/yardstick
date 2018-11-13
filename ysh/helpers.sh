DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Aliases
alias jsonresp="$DIR/http2json/http2json" # filter to jsonify an entire captured response

info()  { $VERBOSE && echo "[INFO ${FUNCNAME[1]}] ${@}"; }
iinfo()  { $VERBOSE && echo "[INFO ${FUNCNAME[2]}] ${@}"; }
warn()  { $VERBOSE && echo "[WARN ${FUNCNAME[1]}] ${@}"; }
err()   { $VERBOSE && echo "[ERRO ${FUNCNAME[1]}] ${@}"; }

# loads all scripts passed in, ie:  RunTests ./test_*   would get all test_* files
# once loaded it then sources shunit2 which runs all test functions
RunTests() {
	# Load all files passed in as $1
	for f in "$@"
	do
        
		info "Loading test script $f"
		. "$f"
	done
	# run shunit
	. "$DIR/shunit2"
}

# jsonify takes the arguments of httpie and invokes http parsing the output to json
# ready for testing with shunit2 and jq
jhttp() {
	iinfo http "$@"
	RAW_RESPONSE=`http --print=hb "$@"`
	RESPONSE=`echo "$RAW_RESPONSE" | $DIR/http2json/http2json`
	HEADERS=`echo "$RESPONSE" | jq '.Header'`
	BODY=`echo "$RESPONSE" | jq -r '.Body'`
	STATUS=`echo "$RESPONSE" | jq '.Status'`
	STATUS_CODE=`echo "$RESPONSE" | jq '.StatusCode'`
	COOKIES=`echo "$RESPONSE" | jq '.Cookies'`
}

jrpc() {
  local out=$(http --print=b POST "$1" jsonrpc=2.0 method="$2" id=1 params:="$3")
  echo `echo $out | jq '.result'`
}

# echo the raw value of a jq match against some json
jval() {
	echo `echo $1 | jq -r $2`
}

# asset that the response code from jhttp is 200
assertStatusOK() {
	assertEquals "Status OK?" 200 "$STATUS_CODE"
}

