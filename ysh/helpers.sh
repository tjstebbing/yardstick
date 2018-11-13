

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

