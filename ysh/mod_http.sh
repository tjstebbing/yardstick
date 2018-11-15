
__depends 'httpie'

# Aliases
case "$OSTYPE" in
	darwin*)  __http2json="$DIR/http2json/darwin_amd64" ;; 
	linux*)   __http2json="$DIR/http2json/linux_amd64" ;;
	*)        __die "http module not compiled for $OSTYPE" ;;
esac

yard_http() {
	export HEADERS BODY STATUS_CODE STATUS COOKIES
	iinfo http "$@"
	RAW_RESPONSE=$(http --print=hb "$@")
	RESPONSE=$(echo "$RAW_RESPONSE" | $__http2json)
	HEADERS=$(echo "$RESPONSE" | jq '.Header')
	BODY=$(echo "$RESPONSE" | jq -r '.Body')
	STATUS=$(echo "$RESPONSE" | jq '.Status')
	STATUS_CODE=$(echo "$RESPONSE" | jq '.StatusCode')
	COOKIES=$(echo "$RESPONSE" | jq '.Cookies')
}

yard_get() {
	yard_http get "$@"
}

yard_head() {
	yard_http head "$@"
}

yard_post() {
	yard_http post "$@"
}

yard_put() {
	yard_http put "$@"
}

yard_delete() {
	yard_http delete "$@"
}

yard_options() {
	yard_http options "$@"
}
