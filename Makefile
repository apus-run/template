.PHONY: setup fmt lint test mocks test_coverage tidy check docker_up docker_down

GO_PKGS   := $(shell go list -f {{.Dir}} ./...)

# 初始化环境
setup:
	@sh ./scripts/setup.sh

fmt:
	@sh ./scripts/fmt.sh

lint:
	@golangci-lint run -c .golangci.yml

test:
	@go test -race -v $(GO_FLAGS) -count=1 $(GO_PKGS)

test_coverage:
	@go test -race -v $(GO_FLAGS) -count=1 -coverprofile=coverage.out -covermode=atomic $(GO_PKGS)
	@go tool cover -html coverage.out

mocks:
	@go generate ./...

tidy:
	@go mod tidy -v

check:
	@$(MAKE) --no-print-directory fmt
	@$(MAKE) --no-print-directory tidy

# docker 安装并运行服务
docker_up:
	docker-compose -f scripts/docker/docker-compose.yml up -d
# docker 停止服务	
docker_down:
	docker-compose -f scripts/docker/docker-compose.yml down -v