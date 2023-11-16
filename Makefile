APP_PATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
SCRIPTS_PATH:=$(APP_PATH)/scripts

.PHONY: setup fmt lint test mocks test_coverage tidy check docker_up docker_down

GO_PKGS   := $(shell go list -f {{.Dir}} ./...)

# 初始化环境
setup:
	@echo "初始化开发环境......"
	@find "$(SCRIPTS_PATH)" -type f -name '*.sh' -exec chmod +x {} \;
	@sh ${SCRIPTS_PATH}/setup.sh
	@make tidy

# 代码风格
fmt:
	@sh ${SCRIPTS_PATH}/fmt.sh

# 静态扫描
lint:
	@golangci-lint run -c .golangci.yml

test:
	@go test -race -v $(GO_FLAGS) -count=1 $(GO_PKGS)

test_coverage:
	@go test -race -v $(GO_FLAGS) -count=1 -coverprofile=coverage.out -covermode=atomic $(GO_PKGS)
	@go tool cover -html coverage.out

mocks:
	@go generate ./...

# 依赖清理
tidy:
	@go mod tidy -v

check:
    @echo "整理项目依赖中......"
    @$(MAKE) --no-print-directory tidy
	@echo "代码风格检查中......"
	@$(MAKE) --no-print-directory fmt
	@echo "代码静态扫描中......"
	@$(MAKE) lint

# 启动本地研发 docker 依赖
docker_up:
	docker-compose -f scripts/docker/docker-compose.yml up -d
# 停止本地研发 docker	
docker_down:
	docker-compose -f scripts/docker/docker-compose.yml down -v