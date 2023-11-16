#!/bin/sh

# Check Go installation
echo "检查 Go版本、Docker、Docker Compose V2......"
GO_VERSION="1.21"  # Specify the required Go version
if ! command -v go >/dev/null || [[ ! "$(go version | awk '{print $3}')" == *"$GO_VERSION"* ]]; then
    echo "Go $GO_VERSION 未安装或者版本不正确"
    exit 1  # 退出并返回错误代码
fi

if ! command -v docker >/dev/null; then
    echo "Docker 未安装"
    exit 1  # Exit with an error code
fi

if ! command -v docker compose >/dev/null; then
    echo "Docker Compose V2未安装"
    exit 1  # Exit with an error code
fi

DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_COMMIT=$DIR/git/pre-commit
TARGET_COMMIT=.git/hooks/pre-commit
SOURCE_PUSH=$DIR/git/pre-push
TARGET_PUSH=.git/hooks/pre-push

# copy pre-commit file if not exist.
if [ ! -f $TARGET_COMMIT ]; then
    echo "设置 git pre-commit hooks..."
    cp $SOURCE_COMMIT $TARGET_COMMIT
fi

# copy pre-push file if not exist.
if [ ! -f $TARGET_PUSH ]; then
    echo "设置 git pre-push hooks..."
    cp $SOURCE_PUSH $TARGET_PUSH
fi

# add permission to TARGET_PUSH and TARGET_COMMIT file.
test -x $TARGET_PUSH || chmod +x $TARGET_PUSH
test -x $TARGET_COMMIT || chmod +x $TARGET_COMMIT

echo "安装 golangci-lint..."
go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.54.2

echo "安装 goimports..."
go install golang.org/x/tools/cmd/goimports@latest

echo "安装 gofumpt......"
go install mvdan.cc/gofumpt@latest