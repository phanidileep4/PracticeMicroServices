#!/bin/bash

# Deploy microservices to Google Cloud Run
# Run this script after build-and-push.sh

set -e

# Configuration
PROJECT_ID=${1:-"homefood-436801"}
REGION="us-central1"
REGISTRY="gcr.io"

echo "Deploying microservices to Google Cloud Run for project: $PROJECT_ID"

# Deploy Eureka Server first (discovery service)
echo "Deploying Eureka Server..."
EUREKA_URL=$(gcloud run deploy eureka-service \
  --image $REGISTRY/$PROJECT_ID/eureka:latest \
  --platform managed \
  --region $REGION \
  --allow-unauthenticated \
  --port 8761 \
  --memory 1Gi \
  --cpu 1 \
  --max-instances 3 \
  --set-env-vars SPRING_PROFILES_ACTIVE=cloud \
  --format="value(status.url)")

echo "Eureka Server deployed at: $EUREKA_URL"

# Wait a moment for Eureka to be ready
echo "Waiting for Eureka Server to be ready..."
sleep 30

# Deploy User Service
echo "Deploying User Service..."
gcloud run deploy userinfo-service \
  --image $REGISTRY/$PROJECT_ID/userinfo:latest \
  --platform managed \
  --region $REGION \
  --allow-unauthenticated \
  --port 9098 \
  --memory 1Gi \
  --cpu 1 \
  --max-instances 3 \
  --set-env-vars EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=$EUREKA_URL/eureka/,SPRING_PROFILES_ACTIVE=cloud

# Deploy Chef Service
echo "Deploying Chef Service..."
gcloud run deploy cheflisting-service \
  --image $REGISTRY/$PROJECT_ID/cheflisting:latest \
  --platform managed \
  --region $REGION \
  --allow-unauthenticated \
  --port 9091 \
  --memory 1Gi \
  --cpu 1 \
  --max-instances 3 \
  --set-env-vars EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=$EUREKA_URL/eureka/,SPRING_PROFILES_ACTIVE=cloud

# Deploy Food Catalogue Service
echo "Deploying Food Catalogue Service..."
gcloud run deploy foodcatalogue-service \
  --image $REGISTRY/$PROJECT_ID/foodcatalogue:latest \
  --platform managed \
  --region $REGION \
  --allow-unauthenticated \
  --port 9095 \
  --memory 1Gi \
  --cpu 1 \
  --max-instances 3 \
  --set-env-vars EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=$EUREKA_URL/eureka/,SPRING_PROFILES_ACTIVE=cloud

# Deploy Order Service
echo "Deploying Order Service..."
gcloud run deploy order-service \
  --image $REGISTRY/$PROJECT_ID/order:latest \
  --platform managed \
  --region $REGION \
  --allow-unauthenticated \
  --port 9097 \
  --memory 1Gi \
  --cpu 1 \
  --max-instances 3 \
  --set-env-vars EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=$EUREKA_URL/eureka/,SPRING_PROFILES_ACTIVE=cloud

echo "All services deployed successfully!"
echo ""
echo "Service URLs:"
echo "Eureka Server: $EUREKA_URL"
echo "User Service: $(gcloud run services describe userinfo-service --region=$REGION --format='value(status.url)')"
echo "Chef Service: $(gcloud run services describe cheflisting-service --region=$REGION --format='value(status.url)')"
echo "Food Catalogue Service: $(gcloud run services describe foodcatalogue-service --region=$REGION --format='value(status.url)')"
echo "Order Service: $(gcloud run services describe order-service --region=$REGION --format='value(status.url)')"