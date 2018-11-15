export mod_json=true

__depends 'jq'


# echo the raw value of a jq match against some json
yard_j() {
	echo "$(echo "$1" | jq -r "$2")"
}
