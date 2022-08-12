#!/bin/bash

npm run lint

if [ $? -eq 1 ]; then
        echo "Something wrong with quality"
        exit 1
fi

npm run e2e

if [ $? -eq 1 ]; then
       echo "Something wrong with e2e tests"
       exit 1
fi

npm run test

if [ $? -eq 1 ]; then
        echo "Something wrong with tests"
        exit 1
fi

echo "All good with project"

