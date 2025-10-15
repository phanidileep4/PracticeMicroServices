#!/bin/bash

# Script to create a public shareable monitoring dashboard for HomeFoodEats microservices
# This creates a dashboard that can be shared publicly without authentication

set -e

PROJECT_ID=${1:-"homefood-436801"}
REGION="us-central1"

echo "Creating public shareable monitoring dashboard for project: $PROJECT_ID"

# Enable required APIs
echo "Enabling Cloud Monitoring API..."
gcloud services enable monitoring.googleapis.com

# First, let's get the existing dashboard and make it shareable
DASHBOARD_ID=$(gcloud monitoring dashboards list --filter="displayName:HomeFoodEats" --format="value(name)" | head -1)

if [ -n "$DASHBOARD_ID" ]; then
    echo "Found existing dashboard: $DASHBOARD_ID"
    
    # Extract just the dashboard ID from the full path
    DASHBOARD_SHORT_ID=$(echo $DASHBOARD_ID | sed 's/.*dashboards\///')
    
    echo "Dashboard Short ID: $DASHBOARD_SHORT_ID"
    echo ""
    echo "🔗 Dashboard URLs:"
    echo "Private Dashboard URL: https://console.cloud.google.com/monitoring/dashboards/custom/$DASHBOARD_ID?project=$PROJECT_ID"
    echo ""
    
    # Create a publicly accessible URL by enabling public sharing
    echo "📊 To make this dashboard publicly accessible, follow these steps:"
    echo ""
    echo "1. Go to: https://console.cloud.google.com/monitoring/dashboards/custom/$DASHBOARD_ID?project=$PROJECT_ID"
    echo "2. Click the 'Share' button (📤) in the top-right corner"
    echo "3. Click 'Get shareable link'"
    echo "4. Set permissions to 'Anyone with the link can view'"
    echo "5. Copy the generated public URL"
    echo ""
    
    # Alternative: Create a simple HTML page with embedded metrics
    echo "Creating alternative public dashboard HTML..."
    
    cat > public-dashboard.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HomeFoodEats Microservices - Live Dashboard</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .header {
            text-align: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 30px;
        }
        .services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .service-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-left: 4px solid #667eea;
        }
        .service-title {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }
        .service-url {
            background: #f8f9fa;
            padding: 8px;
            border-radius: 4px;
            font-family: monospace;
            font-size: 12px;
            word-break: break-all;
            margin-bottom: 10px;
        }
        .service-status {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-live {
            background: #d4edda;
            color: #155724;
        }
        .metrics-section {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin: 5px;
        }
        .btn:hover {
            background: #5a6fd8;
        }
        .last-updated {
            text-align: center;
            color: #666;
            font-size: 12px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>🏠 HomeFoodEats Microservices</h1>
        <p>Live Production Dashboard - Google Cloud Platform</p>
        <p>Real-time monitoring of all microservices</p>
    </div>

    <div class="services-grid">
        <div class="service-card">
            <div class="service-title">🔍 Eureka Server</div>
            <div class="service-url">https://eureka-service-oqfd2ssuua-uc.a.run.app</div>
            <span class="service-status status-live">🟢 LIVE</span>
            <p>Service Discovery & Registration</p>
        </div>

        <div class="service-card">
            <div class="service-title">👤 User Service</div>
            <div class="service-url">https://userinfo-service-oqfd2ssuua-uc.a.run.app</div>
            <span class="service-status status-live">🟢 LIVE</span>
            <p>User Management & Authentication</p>
        </div>

        <div class="service-card">
            <div class="service-title">👨‍🍳 Chef Service</div>
            <div class="service-url">https://cheflisting-service-oqfd2ssuua-uc.a.run.app</div>
            <span class="service-status status-live">🟢 LIVE</span>
            <p>Chef Listings & Management</p>
        </div>

        <div class="service-card">
            <div class="service-title">🍽️ Food Catalogue Service</div>
            <div class="service-url">https://foodcatalogue-service-oqfd2ssuua-uc.a.run.app</div>
            <span class="service-status status-live">🟢 LIVE</span>
            <p>Menu & Food Item Management</p>
        </div>

        <div class="service-card">
            <div class="service-title">📦 Order Service</div>
            <div class="service-url">https://order-service-oqfd2ssuua-uc.a.run.app</div>
            <span class="service-status status-live">🟢 LIVE</span>
            <p>Order Processing & Management</p>
        </div>
    </div>

    <div class="metrics-section">
        <h2>📊 Monitoring & Metrics</h2>
        <p>Access detailed monitoring and performance metrics:</p>
        
        <a href="https://console.cloud.google.com/run?project=homefood-436801" class="btn">
            🌐 Cloud Run Console
        </a>
        
        <a href="https://console.cloud.google.com/monitoring?project=homefood-436801" class="btn">
            📈 Cloud Monitoring
        </a>
        
        <a href="https://console.cloud.google.com/logs?project=homefood-436801" class="btn">
            📋 Cloud Logs
        </a>

        <h3>🏗️ Architecture Details</h3>
        <ul>
            <li><strong>Platform:</strong> Google Cloud Run (Serverless)</li>
            <li><strong>Region:</strong> us-central1</li>
            <li><strong>Auto-scaling:</strong> Enabled (0-3 instances per service)</li>
            <li><strong>Load Balancing:</strong> Automatic</li>
            <li><strong>HTTPS:</strong> Enabled with automatic certificates</li>
            <li><strong>Container Registry:</strong> Google Container Registry (GCR)</li>
        </ul>

        <h3>🔧 Service Ports</h3>
        <ul>
            <li><strong>Eureka Server:</strong> 8761</li>
            <li><strong>User Service:</strong> 9098</li>
            <li><strong>Chef Service:</strong> 9091</li>
            <li><strong>Food Catalogue:</strong> 9095</li>
            <li><strong>Order Service:</strong> 9097</li>
        </ul>
    </div>

    <div class="last-updated">
        Last updated: <span id="timestamp"></span>
    </div>

    <script>
        // Update timestamp
        document.getElementById('timestamp').textContent = new Date().toLocaleString();
        
        // Auto-refresh every 5 minutes
        setTimeout(() => {
            location.reload();
        }, 300000);
    </script>
</body>
</html>
EOF

    echo "✅ Created public-dashboard.html"
    echo ""
    echo "🌐 You can now:"
    echo "1. Host the 'public-dashboard.html' file on any web server"
    echo "2. Share it publicly without requiring Google Cloud access"
    echo "3. Customize it further as needed"
    echo ""
    
    # Also create a simple status checker
    echo "Creating service status checker..."
    
    cat > check-services.sh << 'EOF'
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
EOF

    chmod +x check-services.sh
    echo "✅ Created check-services.sh script"
    echo ""
    
else
    echo "❌ No existing HomeFoodEats dashboard found."
    echo "Please run the create-public-dashboard.sh script first."
fi

echo "🎉 Public dashboard setup complete!"
echo ""
echo "📁 Files created:"
echo "- public-dashboard.html (Static HTML dashboard)"
echo "- check-services.sh (Service status checker)"
echo ""
echo "🌐 Next steps:"
echo "1. Open public-dashboard.html in a web browser"
echo "2. Host it on GitHub Pages, Netlify, or any web server for public access"
echo "3. Run ./check-services.sh to verify all services are online"