#!/bin/bash

# Manual Build and Deploy Script for HomeFoodEats Microservices
# This script provides step-by-step manual deployment process

PROJECT_ID="homefood-436801"
REGION="us-central1"
REGISTRY="gcr.io"

echo "🚀 Manual Build and Deploy Process for HomeFoodEats Microservices"
echo "=================================================================="
echo ""

echo "📋 Step 1: Prerequisites Check"
echo "------------------------------"
echo "✓ Java 17 installed: $(java -version 2>&1 | head -n 1)"
echo "✓ Maven installed: $(mvn -version 2>&1 | head -n 1)"
echo "✓ Docker installed: $(docker --version)"
echo "✓ gcloud installed: $(gcloud version 2>&1 | head -n 1)"
echo ""

read -p "Press Enter to continue with Step 2..."

echo "📦 Step 2: Build JAR files for all services"
echo "--------------------------------------------"
echo ""

echo "Building Eureka Server..."
cd ../eureka
mvn clean package -DskipTests
echo "✅ Eureka JAR built: $(ls -la target/*.jar | grep -v original)"
echo ""

echo "Building User Service..."
cd ../userinfo
mvn clean package -DskipTests
echo "✅ User Service JAR built: $(ls -la target/*.jar | grep -v original)"
echo ""

echo "Building Chef Service..."
cd ../chefListing
mvn clean package -DskipTests
echo "✅ Chef Service JAR built: $(ls -la target/*.jar | grep -v original)"
echo ""

echo "Building Food Catalogue Service..."
cd ../foodcatalogue
mvn clean package -DskipTests
echo "✅ Food Catalogue JAR built: $(ls -la target/*.jar | grep -v original)"
echo ""

echo "Building Order Service..."
cd ../order
mvn clean package -DskipTests
echo "✅ Order Service JAR built: $(ls -la target/*.jar | grep -v original)"
echo ""

read -p "Press Enter to continue with Step 3..."

echo "🐳 Step 3: Build Docker Images"
echo "-------------------------------"
echo ""

echo "Building Eureka Docker image..."
cd ../eureka
docker build --platform linux/amd64 -t $REGISTRY/$PROJECT_ID/eureka:latest .
echo "✅ Eureka Docker image built"
echo ""

echo "Building User Service Docker image..."
cd ../userinfo
docker build --platform linux/amd64 -t $REGISTRY/$PROJECT_ID/userinfo:latest .
echo "✅ User Service Docker image built"
echo ""

echo "Building Chef Service Docker image..."
cd ../chefListing
docker build --platform linux/amd64 -t $REGISTRY/$PROJECT_ID/cheflisting:latest .
echo "✅ Chef Service Docker image built"
echo ""

echo "Building Food Catalogue Service Docker image..."
cd ../foodcatalogue
docker build --platform linux/amd64 -t $REGISTRY/$PROJECT_ID/foodcatalogue:latest .
echo "✅ Food Catalogue Service Docker image built"
echo ""

echo "Building Order Service Docker image..."
cd ../order
docker build --platform linux/amd64 -t $REGISTRY/$PROJECT_ID/order:latest .
echo "✅ Order Service Docker image built"
echo ""

read -p "Press Enter to continue with Step 4..."

echo "🚢 Step 4: Push Images to Google Container Registry"
echo "---------------------------------------------------"
echo ""

echo "Configuring Docker for Google Cloud..."
gcloud auth configure-docker
echo ""

echo "Pushing Eureka image..."
docker push $REGISTRY/$PROJECT_ID/eureka:latest
echo "✅ Eureka image pushed"
echo ""

echo "Pushing User Service image..."
docker push $REGISTRY/$PROJECT_ID/userinfo:latest
echo "✅ User Service image pushed"
echo ""

echo "Pushing Chef Service image..."
docker push $REGISTRY/$PROJECT_ID/cheflisting:latest
echo "✅ Chef Service image pushed"
echo ""

echo "Pushing Food Catalogue Service image..."
docker push $REGISTRY/$PROJECT_ID/foodcatalogue:latest
echo "✅ Food Catalogue Service image pushed"
echo ""

echo "Pushing Order Service image..."
docker push $REGISTRY/$PROJECT_ID/order:latest
echo "✅ Order Service image pushed"
echo ""

read -p "Press Enter to continue with Step 5..."

echo "☁️ Step 5: Deploy to Google Cloud Run"
echo "--------------------------------------"
echo ""

echo "Deploying Eureka Server (Service Discovery)..."
EUREKA_URL=$(gcloud run deploy eureka-service \
    --image $REGISTRY/$PROJECT_ID/eureka:latest \
    --platform managed \
    --region $REGION \
    --allow-unauthenticated \
    --memory 1Gi \
    --cpu 1 \
    --timeout 600 \
    --max-instances 1 \
    --set-env-vars SPRING_PROFILES_ACTIVE=cloud \
    --project $PROJECT_ID \
    --format="value(status.url)")

echo "✅ Eureka Server deployed at: $EUREKA_URL"
echo ""

echo "Waiting for Eureka to be ready..."
sleep 30
echo ""

echo "Deploying User Service..."
gcloud run deploy userinfo-service \
    --image $REGISTRY/$PROJECT_ID/userinfo:latest \
    --platform managed \
    --region $REGION \
    --allow-unauthenticated \
    --memory 1Gi \
    --cpu 1 \
    --timeout 600 \
    --max-instances 3 \
    --set-env-vars EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=$EUREKA_URL/eureka/,SPRING_PROFILES_ACTIVE=cloud \
    --project $PROJECT_ID

echo "✅ User Service deployed"
echo ""

echo "Deploying Chef Service..."
gcloud run deploy cheflisting-service \
    --image $REGISTRY/$PROJECT_ID/cheflisting:latest \
    --platform managed \
    --region $REGION \
    --allow-unauthenticated \
    --memory 1Gi \
    --cpu 1 \
    --timeout 600 \
    --max-instances 3 \
    --set-env-vars EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=$EUREKA_URL/eureka/,SPRING_PROFILES_ACTIVE=cloud \
    --project $PROJECT_ID

echo "✅ Chef Service deployed"
echo ""

echo "Deploying Food Catalogue Service..."
gcloud run deploy foodcatalogue-service \
    --image $REGISTRY/$PROJECT_ID/foodcatalogue:latest \
    --platform managed \
    --region $REGION \
    --allow-unauthenticated \
    --memory 1Gi \
    --cpu 1 \
    --timeout 600 \
    --max-instances 3 \
    --set-env-vars EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=$EUREKA_URL/eureka/,SPRING_PROFILES_ACTIVE=cloud \
    --project $PROJECT_ID

echo "✅ Food Catalogue Service deployed"
echo ""

echo "Deploying Order Service..."
gcloud run deploy order-service \
    --image $REGISTRY/$PROJECT_ID/order:latest \
    --platform managed \
    --region $REGION \
    --allow-unauthenticated \
    --memory 1Gi \
    --cpu 1 \
    --timeout 600 \
    --max-instances 3 \
    --set-env-vars EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=$EUREKA_URL/eureka/,SPRING_PROFILES_ACTIVE=cloud \
    --project $PROJECT_ID

echo "✅ Order Service deployed"
echo ""

echo "🔍 Step 6: Verify Deployment"
echo "-----------------------------"
echo ""

echo "Checking service status..."
gcloud run services list --project=$PROJECT_ID --region=$REGION

echo ""
echo "🎉 Deployment Complete!"
echo "======================="
echo ""
echo "Service URLs:"
echo "🔍 Eureka Server: $EUREKA_URL"
echo "👤 User Service: $(gcloud run services describe userinfo-service --region=$REGION --project=$PROJECT_ID --format='value(status.url)' 2>/dev/null)"
echo "👨‍🍳 Chef Service: $(gcloud run services describe cheflisting-service --region=$REGION --project=$PROJECT_ID --format='value(status.url)' 2>/dev/null)"
echo "🍽️ Food Catalogue: $(gcloud run services describe foodcatalogue-service --region=$REGION --project=$PROJECT_ID --format='value(status.url)' 2>/dev/null)"
echo "📋 Order Service: $(gcloud run services describe order-service --region=$REGION --project=$PROJECT_ID --format='value(status.url)' 2>/dev/null)"
echo ""
echo "🎯 Next Steps:"
echo "  • Open Eureka Dashboard: $EUREKA_URL"
echo "  • Monitor services: cd eureka && ./monitor-services.sh"
echo "  • Check logs in Google Cloud Console"
echo ""
echo "💡 Your HomeFoodEats microservices are now running in the cloud!"