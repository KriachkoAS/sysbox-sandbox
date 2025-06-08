#!/bin/bash
if [ -z ${1+1} ]; then
	path="."
else
	path=$1
fi
path=$(readlink -f $path)
vscode_commit=$(code --no-sandbox --user-data-dir /tmp -v | sed -n '2p')
compose_path="/some/path"
home_dir="/home/username"

HOME_DIR=$home_dir \
WORKSPACE_PATH=$path \
VSCODE_COMMIT=$vscode_commit \
docker compose \
	-f $compose_path \
	up \
	--build sandbox