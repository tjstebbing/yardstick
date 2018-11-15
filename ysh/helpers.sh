


jrpc() {
  local out=$(http --print=b POST "$1" jsonrpc=2.0 method="$2" id=1 params:="$3")
  echo `echo $out | jq '.result'`
}



# asset that the response code from jhttp is 200
assertStatusOK() {
	assertEquals "Status OK?" 200 "$STATUS_CODE"
}

