#!/bin/bash

JS_DIR=./web/public/
APP_JS=app.js
SOURCES=`cat ./build_tools/sources.list`

for file in ${SOURCES} ; do
    cat $JS_DIR$file >> $APP_JS ;
done

mv $APP_JS  $JS_DIR/js

echo "$APP_JS refreshed!"
