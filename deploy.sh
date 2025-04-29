#!/bin/bash

set -e

IMAGE_NAME="todoist-mcp-server:latest"
CONTAINER_NAME="todoist-mcp-server"

# Build docker image
docker build -t $IMAGE_NAME .

# Stop and remove existing container if any
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
  docker rm -f $CONTAINER_NAME
fi

# Deploy container with .env file
if [ -f .env ]; then
  docker run --name $CONTAINER_NAME --env-file .env -d $IMAGE_NAME
  echo "Server deployed and running as container '$CONTAINER_NAME'."
else
  echo "ERROR: .env file not found. Please create a .env file with TODOIST_API_TOKEN."
  exit 1
fi