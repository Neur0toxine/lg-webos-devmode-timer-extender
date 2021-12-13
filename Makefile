SHELL = /bin/bash -o pipefail
export PATH := $(shell go env GOPATH)/bin:$(PATH)

ROOT_DIR=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
BIN=$(ROOT_DIR)/devmode-extender

all:
	@docker-compose run --rm app

build: deps fmt
	@echo "> Building"
	@CGO_ENABLED=0 GOOS=linux GOARCH=arm go build -ldflags="-s -w" -o $(BIN)_linux_arm . && upx -9 $(BIN)_linux_arm
	@echo $(BIN)_linux_arm
	@CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -ldflags="-s -w" -o $(BIN)_linux_arm64 . && upx -9 $(BIN)_linux_arm64
	@echo $(BIN)_linux_arm64
	@CGO_ENABLED=0 GOOS=linux GOARCH=mips go build -ldflags="-s -w" -o $(BIN)_linux_mips . && upx -9 $(BIN)_linux_mips
	@echo $(BIN)_linux_mips
	@CGO_ENABLED=0 GOOS=linux GOARCH=mipsle go build -ldflags="-s -w" -o $(BIN)_linux_mipsle . && upx -9 $(BIN)_linux_mipsle
	@echo $(BIN)_linux_mipsle
	@CGO_ENABLED=0 GOOS=linux GOARCH=mips64 go build -ldflags="-s -w" -o $(BIN)_linux_mips64 .
	@echo $(BIN)_linux_mips64
	@CGO_ENABLED=0 GOOS=linux GOARCH=mips64le go build -ldflags="-s -w" -o $(BIN)_linux_mips64le .
	@echo $(BIN)_linux_mips64le
	@CGO_ENABLED=0 GOOS=linux GOARCH=386 go build -ldflags="-s -w" -o $(BIN)_linux_386 . && upx -9 $(BIN)_linux_386
	@echo $(BIN)_linux_386
	@CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o $(BIN)_linux_amd64 . && upx -9 $(BIN)_linux_amd64
	@echo $(BIN)_linux_amd64
	@CGO_ENABLED=0 GOOS=windows GOARCH=386 go build -ldflags="-s -w" -o $(BIN)_windows_386.exe . && upx -9 $(BIN)_windows_386.exe
	@echo $(BIN)_windows_386.exe
	@CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -ldflags="-s -w" -o $(BIN)_windows_amd64.exe . && upx -9 $(BIN)_windows_amd64.exe
	@echo $(BIN)_windows_amd64.exe

fmt:
	@echo "> gofmt"
	@gofmt -l -s -w `go list -f '{{.Dir}}' ${ROOT_DIR}/... | grep -v /vendor/`

clean:
	@rm $(BIN)_*

deps:
	@echo "> Dependencies"
	@go mod tidy
	@go mod vendor
