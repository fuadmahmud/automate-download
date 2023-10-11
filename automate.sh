#! /usr/bin/env bash

wget=/usr/bin/wget
tar=/bin/tar
NVM_URL="https://raw.githubusercontent.com/nvm-sh/nvm"
GO_URL="https://golang.org/dl"
GO_URL_JSON="https://go.dev/dl/?mode=json"


PLATFORM=$OSTYPE
ARCH=$(dpkg --print-architecture)


if [ ! -x "$wget" ]; then
  echo "ERROR: No wget found." >&2
  exit 1
elif [ ! -x "$tar" ]; then
  echo "ERROR: No tar found." >&2
  exit 1
fi

NVM_VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep "tag_name" | cut -d : -f 2 | tr -d \" | tr -d \, | tr -d " ")
GO_VERSION=$(curl -s "$GO_URL_JSON" | grep "version" | head -1 | cut -d : -f 2 | tr -d \" | tr -d \,)

if ! $wget ${WGET_OPTS} "${NVM_URL}/$NVM_VERSION/install.sh"; then
  echo "ERROR: can't get nvm" >&2
  exit 1
fi
