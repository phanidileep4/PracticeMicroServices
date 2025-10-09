#!/bin/bash

# Quick status check and deployment verification script
PROJECT_ID="homefood-436801"
REGION="us-central1"

echo "🔍 Checking current Cloud Run services..."
gcloud run services list --project=$PROJECT_ID --region=$REGION

echo ""
echo "🔍 Checking if Eureka service exists..."
EUREKA_URL=$(gcloud run services describe eureka-service --project=$PROJECT_ID --region=$REGION --format='value(status.url)' 2>/dev/null)

if [ ! -z "$EUREKA_URL" ]; then
    echo "✅ Eureka service found at: $EUREKA_URL"
    echo "🔍 Testing if it's responding..."
    curl -I "$EUREKA_URL" 2>/dev/null | head -n 1
else
    echo "❌ No Eureka service found. Starting fresh deployment..."
    
    echo "🏗️ Building and deploying Eureka..."
    cd /Users/phanidileep/IdeaProjects/PracticeMicroServices/eureka
    
    # Build JAR
    mvn clean package -DskipTests
    
    # Build and push Docker image
    docker build --platform linux/amd64 -t gcr.io/$PROJECT_ID/eureka:latest .
    docker push gcr.io/$PROJECT_ID/eureka:latest
    
    # Deploy to Cloud Run
    gcloud run deploy eureka-service \
        --image gcr.io/$PROJECT_ID/eureka:latest \
        --platform managed \
        --region $REGION \
        --allow-unauthenticated \
        --memory 4Gi \
        --cpu 4 \
        --timeout 1200 \
        --max-instances 1 \
        --set-env-vars SPRING_PROFILES_ACTIVE=cloud \
        --project $PROJECT_ID
    
    # Get the URL after deployment
    EUREKA_URL=$(gcloud run services describe eureka-service --project=$PROJECT_ID --region=$REGION --format='value(status.url)' 2>/dev/null)
    
    if [ ! -z "$EUREKA_URL" ]; then
        echo "✅ Eureka successfully deployed at: $EUREKA_URL"
    else
        echo "❌ Deployment failed. Checking logs..."
        gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=eureka-service" --limit=10 --project=$PROJECT_ID
    fi
fi

echo ""
echo "🎯 Summary:"
echo "Project ID: $PROJECT_ID"
echo "Region: $REGION"
echo "Eureka URL: ${EUREKA_URL:-'Not deployed'}"