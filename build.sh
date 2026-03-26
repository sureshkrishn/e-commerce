#!/bin/bash

IMAGE_NAME="sureshkrishn/dev:latest"

echo "🚀 Building Docker image..."
docker build -t $IMAGE_NAME .

echo "📤 Pushing image to Docker Hub..."
docker push $IMAGE_NAME

echo "✅ Build & Push completed"
