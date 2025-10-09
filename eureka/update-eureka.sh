#!/bin/bash

# Quick redeploy script for the existing Eureka service
PROJECT_ID="homefood-436801"
REGION="us-central1"
EUREKA_URL="https://eureka-service-692654636538.us-central1.run.app"

echo "🔄 Rebuilding and redeploying Eureka with optimized configuration..."

# Build the optimized JAR
mvn clean package -DskipTests

# Build and push updated Docker image
docker build --platform linux/amd64 -t gcr.io/$PROJECT_ID/eureka:optimized .
docker push gcr.io/$PROJECT_ID/eureka:optimized

# Update the existing service with the optimized image
gcloud run services update eureka-service \
    --image gcr.io/$PROJECT_ID/eureka:optimized \
    --memory 4Gi \
    --cpu 4 \
    --timeout 1200 \
    --max-instances 1 \
    --min-instances 0 \
    --set-env-vars SPRING_PROFILES_ACTIVE=cloud \
    --project $PROJECT_ID \
    --region $REGION

echo "⏳ Waiting for service to update and become healthy..."
sleep 60

# Test the service health
echo "🔍 Testing Eureka health..."
for i in {1..10}; do
    echo "Attempt $i/10: Testing $EUREKA_URL"
    
    # Test main endpoint
    main_response=$(curl -s -o /dev/null -w "%{http_code}" "$EUREKA_URL" 2>/dev/null || echo "000")
    
    # Test health endpoint
    health_response=$(curl -s -o /dev/null -w "%{http_code}" "$EUREKA_URL/actuator/health" 2>/dev/null || echo "000")
    
    echo "  Main endpoint: HTTP $main_response"
    echo "  Health endpoint: HTTP $health_response"
    
    if [ "$main_response" = "200" ] || [ "$health_response" = "200" ]; then
        echo "✅ Eureka is now healthy and responding!"
        echo "🎯 Eureka Dashboard: $EUREKA_URL"
        echo "🔍 Health Check: $EUREKA_URL/actuator/health"
        break
    else
        echo "⏳ Service still starting up, waiting 30 seconds..."
        sleep 30
    fi
done

# Final status check
echo ""
echo "🔍 Final status check:"
gcloud run services describe eureka-service --project=$PROJECT_ID --region=$REGION --format="table(status.conditions[0].type,status.conditions[0].status)"