#! /usr/bin/env bash

NVM_URL="https://raw.githubusercontent.com/nvm-sh/nvm"
GO_URL="https://golang.org/dl"
GO_URL_JSON="https://go.dev/dl/?mode=json"
GO_DL_EXT=""
PYTHON_URL="https://www.python.org/ftp/python"
PYTHON_DL_EXT=""
PLATFORM=""
ARCH=""
wget=$(whereis wget | cut -d " " -f 2)
tar=$(whereis tar | cut -d " " -f 2)


if [ ! -x "$wget" ]; then
  echo "ERROR: No wget found." >&2
  exit 1
elif [ ! -x "$tar" ]; then
  echo "ERROR: No tar found." >&2
  exit 1
fi


NVM_VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep "tag_name" | cut -d : -f 2 | tr -d \" | tr -d \, | tr -d " ")
GO_VERSION=$(curl -s "$GO_URL_JSON" | grep "version" | head -1 | cut -d : -f 2 | tr -d \" | tr -d \, | tr -d " ")
PYTHON_VERSION=$(curl -s https://api.github.com/repos/python/cpython/tags | grep -E '"name": "[^"]*[^"]*",' | awk -F'": "' '{print $2}' | awk -F'",' '{print $1}' | head -1 | tr -d v)

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  PLATFORM=linux
  ARCH=$(machine | tr -d e)
  GO_DL_EXT="tar.gz"
  PYTHON_DL_EXT="Python-$PYTHON_VERSION.tgz"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  PLATFORM=darwin
  ARCH=$(machine | tr -d e)
  GO_DL_EXT="pkg"
  PYTHON_DL_EXT="python-$PYTHON_VERSION-macos11.pkg"
else
  echo "Unknown OSTYPE"
  exit 1
fi

if ! $wget "${NVM_URL}/$NVM_VERSION/install.sh"; then
  echo "ERROR: can't get nvm" >&2
  exit 1
fi

if ! $wget "$GO_URL/$GO_VERSION.$PLATFORM-$ARCH.$GO_DL_EXT"; then
  echo "ERROR: can't get go package" >&2
  exit 1
fi

if ! $wget "$PYTHON_URL/$PYTHON_VERSION/$PYTHON_DL_EXT"; then
  echo "ERROR: can't get python package" >&2
  exit 1
fi
