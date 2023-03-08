#!/bin/bash

# source download
git clone https://github.com/wwalpha/nodejs-examples-for-demo.git

cd nodejs-examples-for-demo

# Docker login
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Build image
docker build --pull --rm --build-arg ENV=blue -t $REPO_URL:blue .
docker build --pull --rm --build-arg ENV=green -t $REPO_URL:green .

# Push image
docker push $REPO_URL:blue
docker push $REPO_URL:green