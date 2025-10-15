#!/bin/bash

# HomeFoodEats Services Status Checker
echo "🏠 HomeFoodEats Microservices Status Check"
echo "=========================================="
echo ""

services=(
    "Eureka Server:https://eureka-service-oqfd2ssuua-uc.a.run.app"
    "User Service:https://userinfo-service-oqfd2ssuua-uc.a.run.app"
    "Chef Service:https://cheflisting-service-oqfd2ssuua-uc.a.run.app"
    "Food Catalogue:https://foodcatalogue-service-oqfd2ssuua-uc.a.run.app"
    "Order Service:https://order-service-oqfd2ssuua-uc.a.run.app"
)

for service in "${services[@]}"; do
    IFS=':' read -r name url <<< "$service"
    echo -n "$name: "
    
    if curl -s --head --request GET "$url" | grep "200 OK" > /dev/null; then
        echo "🟢 ONLINE"
    else
        echo "🔴 OFFLINE"
    fi
done

echo ""
echo "Check completed at: $(date)"
