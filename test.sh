#!/bin/bash

REPO_PATH=$1
IMAGE_NAME="gitleaks-custom-image:latest"
IMAGE_IS_BUILT=0

# clear gitleaks_output.txt if exists
if [ -f "$REPO_PATH/gitleaks_output.txt" ]; then
  echo "" > "$REPO_PATH/gitleaks_output.txt"
fi

# first check if docker image is already built
if docker image inspect $IMAGE_NAME > /dev/null 2>&1; then
  echo "Gitleaks Docker image already exists."
  # IMAGE_IS_BUILT=1
fi

if [ $IMAGE_IS_BUILT -eq 0 ]; then
  echo "Building Gitleaks Docker image..."
  docker build -t $IMAGE_NAME .
fi

echo "Running Gitleaks scan in $REPO_PATH"
docker run -v $REPO_PATH:"/github/workspace" \
  -e FORMAT="json" \
  -e STOP_ON_FAILURE="true" \
  -e GITHUB_OUTPUT="/github/workspace/gitleaks_output.txt" \
  $IMAGE_NAME
