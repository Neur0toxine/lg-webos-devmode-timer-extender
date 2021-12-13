SHELL = /bin/bash -o pipefail
export PATH := $(shell go env GOPATH)/bin:$(PATH)

ROOT_DIR=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
BIN=$(ROOT_DIR)/devmode-extender

all:
	@docker-compose run --rm app

build: deps fmt
	@echo "> Building"
	# TODO: TinyGo has problems with the arm crosscompilation. See this: https://github.com/tinygo-org/tinygo/issues/1906
	#@CGO_ENABLED=0 GOOS=linux GOARCH=arm tinygo build -o $(BIN)_arm .  && strip $(BIN)_arm && upx -9 $(BIN)_arm
	@CGO_ENABLED=0 GOOS=linux GOARCH=arm go build -ldflags="-s -w" -o $(BIN)_arm . && upx -9 $(BIN)_arm
	@echo $(BIN)_arm
	# TODO: TinyGo has problems with the arm crosscompilation. See this: https://github.com/tinygo-org/tinygo/issues/1906
	#@CGO_ENABLED=0 GOOS=linux GOARCH=arm64 tinygo build -o $(BIN)_arm64 .  && strip $(BIN)_arm64 && upx -9 $(BIN)_arm64
	@CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -ldflags="-s -w" -o $(BIN)_arm64 . && upx -9 $(BIN)_arm64
	@echo $(BIN)_arm64
	@CGO_ENABLED=0 GOOS=windows GOARCH=386 go build -ldflags="-s -w" -o $(BIN)_386.exe . && upx -9 $(BIN)_386.exe
	@echo $(BIN)_386.exe
	@CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -ldflags="-s -w" -o $(BIN)_amd64.exe . && upx -9 $(BIN)_amd64.exe
	@echo $(BIN)_amd64.exe

fmt:
	@echo "> gofmt"
	@gofmt -l -s -w `go list -f '{{.Dir}}' ${ROOT_DIR}/... | grep -v /vendor/`

deps:
	@echo "> Dependencies"
	@go mod tidy
	@go mod vendor
