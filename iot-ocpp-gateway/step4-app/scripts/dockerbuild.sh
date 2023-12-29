#!/bin/bash

# Docker login
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Build image
cd src/ocpp-gateway-container

docker build -t $REPO_URL:latest .
docker push $REPO_URL:latest
