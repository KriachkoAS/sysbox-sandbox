#!/bin/bash
if [ -z ${1+1} ]; then
	path="."
else
	path=$1
fi
vscode_commit=$(code --no-sandbox --user-data-dir /tmp -v | sed -n '2p')
compose_path="/some/path"

WORKSPACE_PATH=$path \
VSCODE_COMMIT=$vscode_commit \
docker compose \
	-f $compose_path
	build

WORKSPACE_PATH=$path \
VSCODE_COMMIT=$vscode_commit \
docker compose \
	-f $compose_path \
	up