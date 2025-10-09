#!/bin/bash

# Monitor and manage deployed microservices in Google Cloud Run

PROJECT_ID=${1:-"homefood-436801"}
REGION="us-central1"

echo "Monitoring microservices for project: $PROJECT_ID"

# Function to check service status with dynamic URL fetching
check_service_status() {
    local service_name=$1
    echo "Checking $service_name..."
    
    # Get service URL dynamically from Google Cloud Run
    local url=$(gcloud run services describe $service_name --region=$REGION --format='value(status.url)' 2>/dev/null)
    
    if [ -z "$url" ]; then
        echo "  ❌ $service_name: Not deployed"
        return 1
    else
        echo "  ✅ $service_name: $url"
        
        # Check if service is responding
        local health_check=$(curl -s -o /dev/null -w "%{http_code}" "$url/actuator/health" 2>/dev/null || echo "000")
        if [ "$health_check" = "200" ]; then
            echo "     🟢 Health check: OK"
        else
            echo "     🔴 Health check: Failed (HTTP $health_check)"
        fi
        return 0
    fi
}

# Function to get all service URLs
get_all_service_urls() {
    echo ""
    echo "=== Current Service URLs ==="
    local services=("eureka-service" "userinfo-service" "cheflisting-service" "foodcatalogue-service" "order-service")
    
    for service in "${services[@]}"; do
        local url=$(gcloud run services describe $service --region=$REGION --format='value(status.url)' 2>/dev/null)
        if [ ! -z "$url" ]; then
            echo "🔗 $service: $url"
        fi
    done
    echo ""
}

# Function to view logs
view_logs() {
    local service_name=$1
    echo "Recent logs for $service_name:"
    gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=$service_name" --limit=10 --format="value(timestamp,severity,textPayload)"
}

# Function to scale service
scale_service() {
    local service_name=$1
    local instances=$2
    echo "Scaling $service_name to $instances instances..."
    gcloud run services update $service_name --region=$REGION --max-instances=$instances
}

# Function to test API endpoints
test_api_endpoints() {
    echo ""
    echo "=== Testing API Endpoints ==="
    
    # Get current URLs
    local eureka_url=$(gcloud run services describe eureka-service --region=$REGION --format='value(status.url)' 2>/dev/null)
    local user_url=$(gcloud run services describe userinfo-service --region=$REGION --format='value(status.url)' 2>/dev/null)
    local chef_url=$(gcloud run services describe cheflisting-service --region=$REGION --format='value(status.url)' 2>/dev/null)
    local food_url=$(gcloud run services describe foodcatalogue-service --region=$REGION --format='value(status.url)' 2>/dev/null)
    local order_url=$(gcloud run services describe order-service --region=$REGION --format='value(status.url)' 2>/dev/null)
    
    # Test sample endpoints
    if [ ! -z "$eureka_url" ]; then
        echo "🔍 Testing Eureka Dashboard: $eureka_url"
        local eureka_status=$(curl -s -o /dev/null -w "%{http_code}" "$eureka_url" 2>/dev/null || echo "000")
        echo "   Response: HTTP $eureka_status"
    fi
    
    if [ ! -z "$user_url" ]; then
        echo "👤 Testing User Service: $user_url/user/fetchAllUsers"
        local user_status=$(curl -s -o /dev/null -w "%{http_code}" "$user_url/user/fetchAllUsers" 2>/dev/null || echo "000")
        echo "   Response: HTTP $user_status"
    fi
    
    echo ""
}

# Main monitoring
echo "=== Service Status ==="

# List of services to monitor
services=("eureka-service" "userinfo-service" "cheflisting-service" "foodcatalogue-service" "order-service")

for service in "${services[@]}"; do
    check_service_status $service
done

# Show management options
echo ""
echo "=== Management Options ==="
echo "1. View logs for a service"
echo "2. Scale a service"
echo "3. View all service URLs"
echo "4. Check Eureka dashboard"
echo "5. Test API endpoints"
echo "6. Update Postman collection with current URLs"
echo "7. Exit"

read -p "Choose an option (1-7): " choice

case $choice in
    1)
        echo "Available services: ${services[*]}"
        read -p "Enter service name: " service_name
        view_logs $service_name
        ;;
    2)
        echo "Available services: ${services[*]}"
        read -p "Enter service name: " service_name
        read -p "Enter max instances: " instances
        scale_service $service_name $instances
        ;;
    3)
        get_all_service_urls
        ;;
    4)
        eureka_url=$(gcloud run services describe eureka-service --region=$REGION --format='value(status.url)' 2>/dev/null)
        if [ ! -z "$eureka_url" ]; then
            echo "🔍 Eureka Dashboard: $eureka_url"
            echo "💡 Open this URL in your browser to view the Eureka dashboard"
        else
            echo "❌ Eureka service not found"
        fi
        ;;
    5)
        test_api_endpoints
        ;;
    6)
        echo "🔄 Generating updated Postman collection with current URLs..."
        # Get current URLs
        eureka_url=$(gcloud run services describe eureka-service --region=$REGION --format='value(status.url)' 2>/dev/null)
        user_url=$(gcloud run services describe userinfo-service --region=$REGION --format='value(status.url)' 2>/dev/null)
        chef_url=$(gcloud run services describe cheflisting-service --region=$REGION --format='value(status.url)' 2>/dev/null)
        food_url=$(gcloud run services describe foodcatalogue-service --region=$REGION --format='value(status.url)' 2>/dev/null)
        order_url=$(gcloud run services describe order-service --region=$REGION --format='value(status.url)' 2>/dev/null)
        
        echo "Current URLs:"
        echo "🔍 Eureka: $eureka_url"
        echo "👤 User: $user_url"
        echo "👨‍🍳 Chef: $chef_url"
        echo "🍽️ Food: $food_url"
        echo "📋 Order: $order_url"
        echo ""
        echo "💡 Update these URLs in your Postman collection environment variables"
        ;;
    7)
        echo "Exiting..."
        ;;
    *)
        echo "Invalid option"
        ;;
esac