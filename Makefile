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
deploy:
	kubectl apply -f deploy/service_account.yaml
	kubectl apply -f deploy/role.yaml
	kubectl apply -f deploy/role_binding.yaml
	kubectl apply -f deploy/crds/gamepod_v1alpha1_gameserver_crd.yaml
	kubectl apply -f deploy/operator.build.yaml
teardown:
	kubectl delete -f deploy/service_account.yaml
	kubectl delete -f deploy/role.yaml
	kubectl delete -f deploy/role_binding.yaml
	kubectl delete -f deploy/crds/gamepod_v1alpha1_gameserver_crd.yaml
	kubectl delete -f deploy/operator.build.yaml