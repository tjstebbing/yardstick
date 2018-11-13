#!/bin/bash

# Install jwt decoder
echo "installing jwt decoder"
go get -u github.com/romeovs/jwt

# build http2json
echo "building scripts/http2json"
cd scripts/http2json
go build http2json

echo "ready to test! run ./test.sh"

