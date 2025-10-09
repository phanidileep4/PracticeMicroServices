#!/bin/bash

# Final comprehensive Eureka deployment script
PROJECT_ID="homefood-436801"
REGION="us-central1"

echo "🔄 Final Eureka deployment with maximum compatibility..."

# Build with the minimal configuration
echo "🏗️ Building with minimal configuration..."
mvn clean package -DskipTests -q

# Build optimized Docker image
echo "🐳 Building Docker image with minimal layers..."
docker build --platform linux/amd64 -t gcr.io/$PROJECT_ID/eureka:final .
docker push gcr.io/$PROJECT_ID/eureka:final

# Deploy with conservative settings for maximum compatibility
echo "🚀 Deploying with conservative settings..."
gcloud run deploy eureka-service \
    --image gcr.io/$PROJECT_ID/eureka:final \
    --platform managed \
    --region $REGION \
    --allow-unauthenticated \
    --memory 1Gi \
    --cpu 1 \
    --timeout 600 \
    --max-instances 1 \
    --min-instances 0 \
    --concurrency 80 \
    --set-env-vars SPRING_PROFILES_ACTIVE=cloud \
    --project $PROJECT_ID

echo "⏳ Waiting for deployment to stabilize..."
sleep 120

# Get service URL and test thoroughly
EUREKA_URL=$(gcloud run services describe eureka-service --region=$REGION --project=$PROJECT_ID --format='value(status.url)')

echo "🔍 Testing deployment..."
echo "Service URL: $EUREKA_URL"

# Test with retries
for i in {1..5}; do
    echo "Test attempt $i/5:"
    
    # Test main endpoint
    main_status=$(curl -s -o /dev/null -w "%{http_code}" "$EUREKA_URL" 2>/dev/null || echo "000")
    echo "  Main endpoint: HTTP $main_status"
    
    # Test health endpoint
    health_status=$(curl -s -o /dev/null -w "%{http_code}" "$EUREKA_URL/actuator/health" 2>/dev/null || echo "000")
    echo "  Health endpoint: HTTP $health_status"
    
    if [ "$health_status" = "200" ] || [ "$main_status" = "200" ]; then
        echo "✅ Eureka is responding successfully!"
        echo "🎯 Eureka Dashboard: $EUREKA_URL"
        echo "🔍 Health Check: $EUREKA_URL/actuator/health"
        
        # Test actual content
        echo "📋 Testing content..."
        curl -s "$EUREKA_URL/actuator/health" | head -n 3
        break
    else
        echo "⏳ Service still starting, waiting 30 seconds..."
        sleep 30
    fi
done

# Final status check
echo ""
echo "🔍 Final service status:"
gcloud run services describe eureka-service --project=$PROJECT_ID --region=$REGION --format="table(status.conditions[0].type,status.conditions[0].status)"

echo ""
echo "✅ Deployment complete!"
echo "🎯 Eureka URL: $EUREKA_URL"