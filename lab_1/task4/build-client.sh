#!/bin/bash

ROOT_DIR=`dirname "$(readlink -f "$BASH_SOURCE")"`

if [ -e "$ROOT_DIR/dist/app.zip" ]
then
	rm "$ROOT_DIR/dist/app.zip"
	echo "Archived project has been removed"
fi

npm install

npm run build --configuration=$ENV_CONFIGURATION --output-path=$ROOT_DIR/dist/static

zip -r $ROOT_DIR/dist/app.zip $ROOT_DIR/dist/static
