# Google Cloud Migration Guide for Practice Microservices

This guide provides complete instructions for migrating your microservices architecture to Google Cloud Platform using Cloud Run.

## Architecture Overview
- **Eureka Server**: Service discovery (Port 8761)
- **User Service**: User management (Port 9098)  
- **Chef Service**: Chef listing management (Port 9091)
- **Food Catalogue Service**: Food catalog management (Port 9095)
- **Order Service**: Order processing (Port 9097)

## Prerequisites
- Install Google Cloud SDK: `https://cloud.google.com/sdk/docs/install`
- Docker installed and running
- Java 17 and Maven installed
- Authenticate: `gcloud auth login`
- Create/Set project: `gcloud config set project YOUR_PROJECT_ID`

## Quick Migration (Automated)

### Step 1: Build and Push Images
```bash
chmod +x build-and-push.sh
./build-and-push.sh YOUR_PROJECT_ID
```

### Step 2: Deploy to Cloud Run
```bash
chmod +x deploy-to-cloudrun.sh
./deploy-to-cloudrun.sh YOUR_PROJECT_ID
```

## Manual Migration Steps

### 1. Enable Required APIs
```bash
gcloud services enable run.googleapis.com
gcloud services enable containerregistry.googleapis.com
gcloud services enable cloudbuild.googleapis.com
```

### 2. Configure Docker Authentication
```bash
gcloud auth configure-docker
```

### 3. Build and Push Each Service

#### Eureka Server
```bash
cd eureka
mvn clean package -DskipTests
docker build -t gcr.io/YOUR_PROJECT_ID/eureka:latest .
docker push gcr.io/YOUR_PROJECT_ID/eureka:latest
```

#### User Service
```bash
cd ../userinfo
mvn clean package -DskipTests
docker build -t gcr.io/YOUR_PROJECT_ID/userinfo:latest .
docker push gcr.io/YOUR_PROJECT_ID/userinfo:latest
```

#### Chef Service
```bash
cd ../chefListing
mvn clean package -DskipTests
docker build -t gcr.io/YOUR_PROJECT_ID/cheflisting:latest .
docker push gcr.io/YOUR_PROJECT_ID/cheflisting:latest
```

#### Food Catalogue Service
```bash
cd ../foodcatalogue
mvn clean package -DskipTests
docker build -t gcr.io/YOUR_PROJECT_ID/foodcatalogue:latest .
docker push gcr.io/YOUR_PROJECT_ID/foodcatalogue:latest
```

#### Order Service
```bash
cd ../order
mvn clean package -DskipTests
docker build -t gcr.io/YOUR_PROJECT_ID/order:latest .
docker push gcr.io/YOUR_PROJECT_ID/order:latest
```

### 4. Deploy Services to Cloud Run

#### Deploy Eureka Server First
```bash
gcloud run deploy eureka-service \
  --image gcr.io/YOUR_PROJECT_ID/eureka:latest \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --port 8761 \
  --memory 1Gi \
  --cpu 1 \
  --max-instances 3 \
  --set-env-vars SPRING_PROFILES_ACTIVE=cloud
```

#### Deploy Other Services (Replace EUREKA_URL with actual URL from above)
```bash
# User Service
gcloud run deploy userinfo-service \
  --image gcr.io/YOUR_PROJECT_ID/userinfo:latest \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --port 9098 \
  --memory 1Gi \
  --set-env-vars EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=https://EUREKA_URL/eureka/,SPRING_PROFILES_ACTIVE=cloud

# Chef Service
gcloud run deploy cheflisting-service \
  --image gcr.io/YOUR_PROJECT_ID/cheflisting:latest \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --port 9091 \
  --memory 1Gi \
  --set-env-vars EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=https://EUREKA_URL/eureka/,SPRING_PROFILES_ACTIVE=cloud

# Food Catalogue Service
gcloud run deploy foodcatalogue-service \
  --image gcr.io/YOUR_PROJECT_ID/foodcatalogue:latest \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --port 9095 \
  --memory 1Gi \
  --set-env-vars EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=https://EUREKA_URL/eureka/,SPRING_PROFILES_ACTIVE=cloud

# Order Service
gcloud run deploy order-service \
  --image gcr.io/YOUR_PROJECT_ID/order:latest \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --port 9097 \
  --memory 1Gi \
  --set-env-vars EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=https://EUREKA_URL/eureka/,SPRING_PROFILES_ACTIVE=cloud
```

## Cloud Configuration

### Environment Variables
Each service will use these environment variables in the cloud:
- `SPRING_PROFILES_ACTIVE=cloud`
- `EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=https://[EUREKA_URL]/eureka/`

### Resource Allocation
- **Memory**: 1Gi per service (adjust based on needs)
- **CPU**: 1 vCPU per service
- **Max Instances**: 3 (auto-scaling enabled)

## Alternative Cloud Platforms

### AWS (Amazon Web Services)
- Use **Amazon ECS** or **AWS Fargate** for containerized deployment
- **Application Load Balancer** for traffic distribution
- **Amazon ECR** for container registry

### Azure
- Use **Azure Container Instances** or **Azure Kubernetes Service**
- **Azure Container Registry** for images
- **Azure Load Balancer** for traffic management

### Cost Optimization Tips
1. Use **Cloud Run** for pay-per-use pricing
2. Enable **auto-scaling** to scale down when not in use
3. Monitor with **Google Cloud Monitoring**
4. Set up **budget alerts**

## Monitoring and Logging
- View logs: `gcloud logging read "resource.type=cloud_run_revision"`
- Monitor metrics in Google Cloud Console
- Set up alerts for high CPU/memory usage

## Rollback Strategy
To rollback to a previous version:
```bash
gcloud run services replace-traffic SERVICE_NAME --to-revisions=REVISION_NAME=100
```

## Troubleshooting
- Check service logs in Cloud Console
- Verify environment variables are set correctly
- Ensure Eureka Server is deployed and accessible first
- Check that all required APIs are enabled