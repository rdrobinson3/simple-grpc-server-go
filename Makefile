SERVER_OUT := "bin/server"
CLIENT_OUT := "bin/client"
API_OUT := "api/api.pb.go"
PKG := "github.com/rdrobinson3/simple-grpc-server-go"
SERVER_PKG_BUILD := "./server"
CLIENT_PKG_BUILD := "./client"
PKG_LIST := $(shell go list ${PKG}/... | grep -v /vendor/)

.PHONY: all api build_server build_client

all: build_server build_client

api/api.pb.go: api/api.proto
	@protoc -I api/ \
		-I${GOPATH}/src \
		--go_out=plugins=grpc:api \
		api/api.proto

api: api/api.pb.go ## Auto-generate grpc go sources

build_server: api ## Build the binary file for server
	@go build -o $(SERVER_OUT) $(SERVER_PKG_BUILD)

build_client: api ## Build the binary file for client
	@go build -o $(CLIENT_OUT) $(CLIENT_PKG_BUILD)

clean: ## Remove previous builds
	@rm $(SERVER_OUT) $(CLIENT_OUT) $(API_OUT)

help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
