#!/bin/bash

OS=linux GOARCH=amd64 go build -o linux_amd64
OS=darwin GOARCH=amd64 go build -o darwin_amd64

