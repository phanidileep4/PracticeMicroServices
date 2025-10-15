#!/bin/bash

# Script to create a public monitoring dashboard for HomeFoodEats microservices
# This dashboard will show service health, performance metrics, and availability

set -e

PROJECT_ID=${1:-"homefood-436801"}
REGION="us-central1"

echo "Creating public monitoring dashboard for project: $PROJECT_ID"

# Enable required APIs
echo "Enabling Cloud Monitoring API..."
gcloud services enable monitoring.googleapis.com

# Create a comprehensive monitoring dashboard
echo "Creating monitoring dashboard..."
cat > dashboard-config.json << 'EOF'
{
  "displayName": "HomeFoodEats Microservices - Public Dashboard",
  "mosaicLayout": {
    "columns": 12,
    "tiles": [
      {
        "width": 6,
        "height": 4,
        "widget": {
          "title": "Total Request Count",
          "scorecard": {
            "timeSeriesQuery": {
              "timeSeriesFilter": {
                "filter": "resource.type=\"cloud_run_revision\" AND metric.type=\"run.googleapis.com/request_count\"",
                "aggregation": {
                  "alignmentPeriod": "300s",
                  "perSeriesAligner": "ALIGN_RATE",
                  "crossSeriesReducer": "REDUCE_SUM"
                }
              }
            },
            "sparkChartView": {
              "sparkChartType": "SPARK_LINE"
            }
          }
        }
      },
      {
        "xPos": 6,
        "width": 6,
        "height": 4,
        "widget": {
          "title": "Request Rate by Service",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "resource.type=\"cloud_run_revision\" AND metric.type=\"run.googleapis.com/request_count\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_RATE",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": ["resource.label.service_name"]
                    }
                  }
                },
                "plotType": "LINE"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "Requests/sec",
              "scale": "LINEAR"
            }
          }
        }
      },
      {
        "yPos": 4,
        "width": 6,
        "height": 4,
        "widget": {
          "title": "Response Latency (95th percentile)",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "resource.type=\"cloud_run_revision\" AND metric.type=\"run.googleapis.com/request_latencies\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_DELTA",
                      "crossSeriesReducer": "REDUCE_PERCENTILE_95",
                      "groupByFields": ["resource.label.service_name"]
                    }
                  }
                },
                "plotType": "LINE"
              }
            ],
            "yAxis": {
              "label": "Latency (ms)",
              "scale": "LINEAR"
            }
          }
        }
      },
      {
        "xPos": 6,
        "yPos": 4,
        "width": 6,
        "height": 4,
        "widget": {
          "title": "Memory Utilization",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "resource.type=\"cloud_run_revision\" AND metric.type=\"run.googleapis.com/container/memory/utilizations\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN",
                      "crossSeriesReducer": "REDUCE_MEAN",
                      "groupByFields": ["resource.label.service_name"]
                    }
                  }
                },
                "plotType": "LINE"
              }
            ],
            "yAxis": {
              "label": "Memory %",
              "scale": "LINEAR"
            }
          }
        }
      },
      {
        "yPos": 8,
        "width": 6,
        "height": 4,
        "widget": {
          "title": "CPU Utilization",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "resource.type=\"cloud_run_revision\" AND metric.type=\"run.googleapis.com/container/cpu/utilizations\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN",
                      "crossSeriesReducer": "REDUCE_MEAN",
                      "groupByFields": ["resource.label.service_name"]
                    }
                  }
                },
                "plotType": "LINE"
              }
            ],
            "yAxis": {
              "label": "CPU %",
              "scale": "LINEAR"
            }
          }
        }
      },
      {
        "xPos": 6,
        "yPos": 8,
        "width": 6,
        "height": 4,
        "widget": {
          "title": "Service Status Overview",
          "text": {
            "content": "# HomeFoodEats Microservices\n\n## 🏠 Architecture Overview\n- **Eureka Server**: Service Discovery (Port 8761)\n- **User Service**: User Management (Port 9098)\n- **Chef Service**: Chef Listings (Port 9091)\n- **Food Catalogue**: Menu Management (Port 9095)\n- **Order Service**: Order Processing (Port 9097)\n\n## 📊 Monitoring\nReal-time metrics showing:\n- Request rates and patterns\n- Response latency (95th percentile)\n- CPU and Memory utilization\n- Service health status\n\n## 🌐 Platform\n- **Cloud Provider**: Google Cloud Platform\n- **Compute**: Cloud Run (Serverless)\n- **Features**: Auto-scaling, Load balancing\n\n---\n*Dashboard updates every 60 seconds*",
            "format": "MARKDOWN"
          }
        }
      }
    ]
  }
}
EOF

# Create the dashboard
gcloud monitoring dashboards create --config-from-file=dashboard-config.json

echo "Dashboard created successfully!"

# Get dashboard information
DASHBOARD_ID=$(gcloud monitoring dashboards list --filter="displayName:HomeFoodEats" --format="value(name)" | head -1)

if [ -n "$DASHBOARD_ID" ]; then
    echo "Dashboard ID: $DASHBOARD_ID"
    echo "Dashboard URL: https://console.cloud.google.com/monitoring/dashboards/custom/$DASHBOARD_ID?project=$PROJECT_ID"
    
    # Make dashboard public (this requires additional setup)
    echo ""
    echo "To make this dashboard publicly accessible:"
    echo "1. Go to the dashboard URL above"
    echo "2. Click 'Share' in the top-right corner"
    echo "3. Select 'Get shareable link'"
    echo "4. Choose appropriate permissions (public or specific users)"
fi

# Clean up
rm -f dashboard-config.json

echo ""
echo "Public dashboard setup complete!"