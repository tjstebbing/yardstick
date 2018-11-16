#!/bin/bash

env GOOS=linux GOARCH=amd64 go build -o linux_amd64
env GOOS=darwin GOARCH=amd64 go build -o darwin_amd64

