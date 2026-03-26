#!/bin/bash

ENV=$1

if [ "$ENV" == "prod" ]; then
  IMAGE_NAME="sureshkrishn/prod:latest"
else
  IMAGE_NAME="sureshkrishn/dev:latest"
fi

echo "🚀 Building Docker image for $ENV..."

docker build -t $IMAGE_NAME .

if [ $? -ne 0 ]; then
  echo "❌ Build failed"
  exit 1
fi

echo "📤 Pushing image to Docker Hub..."
docker push $IMAGE_NAME

if [ $? -ne 0 ]; then
  echo "❌ Push failed"
  exit 1
fi

echo "✅ Image pushed successfully: $IMAGE_NAME"
