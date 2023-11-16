#!/bin/sh

goimports -l -w $(find . -type f -name '*.go' -not -path "./.idea/*")
gofumpt -l -w $(find . -type f -name '*.go' -not -path "./.idea/*")