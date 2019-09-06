GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get
BINARY_NAME=agent
GOFLAGS="-gcflags=all=-trimpath=${GOPATH} -asmflags=all=-trimpath=${GOPATH}"

all: test build
test:
	$(GOTEST) -v ./...
build:
	$(GOBUILD) $(GOFLAGS) -o $(BINARY_NAME) -v gamepod.cc/agent/cmd/manager
clean: 
	$(GOCLEAN)
	rm -f $(BINARY_NAME)
docker-build:
	docker build --cache-from gamepod/agent:build -f build/Dockerfile -t gamepod/agent:build .