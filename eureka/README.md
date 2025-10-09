# 🍽️ HomeFoodEats Microservices - Production Ready

A comprehensive cloud-native microservices architecture for a food delivery platform built with Spring Boot, Spring Cloud, and deployed on Google Cloud Run.

## 🌟 **LIVE DEPLOYMENT** 
✅ **All services are currently running on Google Cloud Run!**

### 🔗 **Production URLs:**
- 🔍 **Eureka Server**: https://eureka-service-692654636538.us-central1.run.app
- 👤 **User Service**: https://userinfo-service-692654636538.us-central1.run.app
- 👨‍🍳 **Chef Service**: https://cheflisting-service-692654636538.us-central1.run.app
- 🍽️ **Food Catalogue**: https://foodcatalogue-service-692654636538.us-central1.run.app
- 📋 **Order Service**: https://order-service-692654636538.us-central1.run.app

---

## 🏗️ **Architecture Overview**

### **Microservices Architecture Pattern**
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Eureka Server │    │   User Service  │    │  Chef Service   │
│   (Discovery)   │◄──►│   (Port 9098)   │    │  (Port 9091)    │
│   (Port 8761)   │    └─────────────────┘    └─────────────────┘
└─────────────────┘              │                      │
        ▲                        │                      │
        │                        ▼                      ▼
        │            ┌─────────────────┐    ┌─────────────────┐
        └────────────┤ Order Service   │◄──►│Food Catalogue   │
                     │ (Port 9097)     │    │ (Port 9095)     │
                     └─────────────────┘    └─────────────────┘
                              │                      │
                              └──────────────────────┘
                                   MongoDB Atlas
```

### **Service Responsibilities**
- **🔍 Eureka Server**: Service Discovery, Health Monitoring, Load Balancing
- **👤 User Service**: User registration, authentication, profile management
- **👨‍🍳 Chef Service**: Chef onboarding, profile management, chef listings
- **🍽️ Food Catalogue Service**: Menu management, food items, chef-food mapping
- **📋 Order Service**: Order processing, payment handling, order tracking

---

## 💻 **Tech Stack**

### **🏗️ Core Technologies**
- **Java 17** - Programming Language
- **Spring Boot 3.4.0** - Application Framework
- **Spring Cloud 2024.0.0-RC1** - Microservices Ecosystem
- **Maven** - Build & Dependency Management

### **🌐 Spring Boot Modules**
- **Spring Boot Starter Web** - REST API Development
- **Spring Boot Starter Data MongoDB** - Database Integration
- **Spring Boot Starter Actuator** - Health Monitoring & Metrics
- **Spring Cloud Netflix Eureka** - Service Discovery

### **🗄️ Database & Persistence**
- **MongoDB Atlas** - Cloud NoSQL Database
- **Spring Data MongoDB** - Database Abstraction

### **🐳 Containerization & Cloud**
- **Docker** - Application Containerization
- **Google Cloud Run** - Serverless Container Platform
- **Google Container Registry** - Container Image Storage
- **Google Cloud Platform** - Cloud Infrastructure

### **🔧 DevOps & Monitoring**
- **Spring Boot Actuator** - Application Health Checks
- **Bash Scripts** - Automated Deployment
- **Google Cloud Logging** - Centralized Logging
- **Postman** - API Testing & Documentation

---

## 🚀 **Quick Start Guide**

### **Option 1: Test Live APIs (Recommended)**
```bash
# Import the Postman collection
File: HomeFoodEats-Production-APIs.postman_collection.json

# Test health endpoints
curl https://eureka-service-692654636538.us-central1.run.app/actuator/health
```

### **Option 2: Deploy to Google Cloud**
```bash
# Prerequisites: gcloud CLI, Docker, Java 17, Maven
cd eureka
chmod +x build-and-deploy.sh monitor-services.sh

# Deploy all services
./build-and-deploy.sh

# Monitor deployment
./monitor-services.sh
```

### **Option 3: Local Development**
```bash
# Start MongoDB (or use Atlas connection)
# Start Eureka Server first
cd eureka && mvn spring-boot:run

# In separate terminals, start other services
cd userinfo && mvn spring-boot:run
cd chefListing && mvn spring-boot:run
cd foodcatalogue && mvn spring-boot:run
cd order && mvn spring-boot:run
```

### **Option 4: Docker Deployment**
```bash
# Build and run with Docker Compose
docker-compose up --build
```

---

## 📱 **API Documentation**

### **🔗 Postman Collection**
**File**: `HomeFoodEats-Production-APIs.postman_collection.json`
- ✅ **Ready-to-use** with live production URLs
- ✅ **Complete sample data** for all endpoints
- ✅ **Health check endpoints** for monitoring
- ✅ **Environment variables** for easy configuration

### **📋 Key Endpoints**

#### **👤 User Service**
```http
GET    /user/fetchAllUsers
GET    /user/fetchUserById/{id}
POST   /user/addUser
GET    /actuator/health
```

#### **👨‍🍳 Chef Service**
```http
GET    /chef/fetchAllChefs
GET    /chef/fetchChefById/{id}
POST   /chef/addChef
GET    /actuator/health
```

#### **🍽️ Food Catalogue Service**
```http
GET    /foodCatalogue/fetchAllFoodItems
GET    /foodCatalogue/fetchFoodCataloguePageByChefId/{chefId}
POST   /foodCatalogue/addFoodItem
GET    /actuator/health
```

#### **📋 Order Service**
```http
POST   /order/processOrder
GET    /actuator/health
```

#### **🔍 Eureka Server**
```http
GET    /
GET    /eureka/apps
GET    /actuator/health
```

---

## 🛠️ **Development Setup**

### **Prerequisites**
```bash
# Check Java version
java --version  # Should be 17+

# Check Maven
mvn --version  # Should be 3.6+

# Check Docker (for cloud deployment)
docker --version

# Check Google Cloud SDK (for cloud deployment)
gcloud --version
```

### **Environment Configuration**
```yaml
# MongoDB Connection (Already configured)
MONGODB_URI: mongodb+srv://homefood-admin:test123@homefood-cluster.e6yvoz7.mongodb.net/homefooddb

# Google Cloud Project
PROJECT_ID: homefood-436801
REGION: us-central1
```

### **Build All Services**
```bash
# Build individual services
cd userinfo && mvn clean package -DskipTests
cd chefListing && mvn clean package -DskipTests
cd foodcatalogue && mvn clean package -DskipTests
cd order && mvn clean package -DskipTests
cd eureka && mvn clean package -DskipTests
```

---

## 🔍 **Monitoring & Health Checks**

### **Service Health Dashboard**
```bash
# Run the monitoring script
./monitor-services.sh

# Expected output:
# ✅ eureka-service: 🟢 Health check: OK
# ✅ userinfo-service: 🟢 Health check: OK
# ✅ cheflisting-service: 🟢 Health check: OK
# ✅ foodcatalogue-service: 🟢 Health check: OK
# ✅ order-service: 🟢 Health check: OK
```

### **Eureka Dashboard**
Visit: https://eureka-service-692654636538.us-central1.run.app
- View registered services
- Monitor service health
- Check service instances

### **Individual Health Checks**
```bash
# Check all services
curl https://eureka-service-692654636538.us-central1.run.app/actuator/health
curl https://userinfo-service-692654636538.us-central1.run.app/actuator/health
curl https://cheflisting-service-692654636538.us-central1.run.app/actuator/health
curl https://foodcatalogue-service-692654636538.us-central1.run.app/actuator/health
curl https://order-service-692654636538.us-central1.run.app/actuator/health
```

---

## 🧪 **Testing Guide**

### **Step 1: Import Postman Collection**
1. Open Postman
2. Click "Import"
3. Select `HomeFoodEats-Production-APIs.postman_collection.json`
4. Collection will load with all production URLs

### **Step 2: Test Workflow**
```
1. 🔍 Check Eureka Dashboard → Verify services are registered
2. 👤 Add a User → Get user ID from response
3. 👨‍🍳 Add a Chef → Get chef ID from response  
4. 🍽️ Add Food Items → Link to chef ID
5. 📋 Create an Order → Use user ID, chef info, and food items
6. 🩺 Run Health Checks → Verify all services are healthy
```

### **Step 3: Sample Test Data**
```json
// Add User
{
    "userName": "John Doe",
    "userEmail": "john.doe@example.com",
    "userAddress": "123 Main Street",
    "userCity": "New York"
}

// Add Chef
{
    "name": "Gordon Ramsay",
    "address": "456 Culinary Avenue", 
    "city": "London",
    "chefDescription": "World-renowned chef"
}

// Add Food Item
{
    "itemName": "Butter Chicken",
    "itemDescription": "Creamy tomato-based curry",
    "itemPrice": 18.99,
    "chefId": "CHEF001",
    "category": "Indian"
}
```

---

## 🌐 **Deployment Architecture**

### **Google Cloud Run Configuration**
```yaml
Eureka Server:
  Memory: 2Gi
  CPU: 2
  Max Instances: 3
  Environment: SPRING_PROFILES_ACTIVE=cloud

Other Services:
  Memory: 1Gi  
  CPU: 1
  Max Instances: 3
  Environment: SPRING_PROFILES_ACTIVE=cloud
```

### **Service Discovery Flow**
1. **Service Startup** → Register with Eureka Server
2. **Health Checks** → Continuous monitoring via Actuator
3. **Load Balancing** → Google Cloud Run handles traffic distribution
4. **Auto Scaling** → Based on CPU/Memory usage

### **Database Configuration**
- **MongoDB Atlas** cluster: `homefood-cluster`
- **Database**: `homefooddb`
- **Collections**: Automatically created per service
- **Connection**: Secure connection string with authentication

---

## 📂 **Project Structure**
```
PracticeMicroServices/
├── eureka/                 # Service Discovery Server
├── userinfo/              # User Management Service
├── chefListing/           # Chef Management Service  
├── foodcatalogue/         # Food Catalog Service
├── order/                 # Order Processing Service
├── HomeFoodEats-Production-APIs.postman_collection.json
└── README.md              # This file
```

---

## 🚀 **Production Features**

### **✅ Implemented**
- ✅ **Service Discovery** with Netflix Eureka
- ✅ **Health Monitoring** with Spring Boot Actuator
- ✅ **Cloud Deployment** on Google Cloud Run
- ✅ **Auto Scaling** and Load Balancing
- ✅ **Centralized Logging** with Google Cloud
- ✅ **API Documentation** with Postman
- ✅ **Automated Deployment** with Bash scripts
- ✅ **Database Integration** with MongoDB Atlas
- ✅ **Containerization** with Docker

### **🔄 Future Enhancements**
- 🔄 **API Gateway** with Spring Cloud Gateway
- 🔄 **Circuit Breaker** with Hystrix/Resilience4j
- 🔄 **Distributed Tracing** with Zipkin/Jaeger
- 🔄 **Authentication** with OAuth2/JWT
- 🔄 **Message Queues** with RabbitMQ/Kafka
- 🔄 **Caching** with Redis
- 🔄 **Config Server** for centralized configuration

---

## 🛡️ **Security & Best Practices**

### **Current Security**
- **HTTPS** for all cloud endpoints
- **MongoDB Atlas** secure connection
- **Google Cloud IAM** for deployment access
- **Environment Variables** for sensitive data

### **Monitoring & Observability**
- **Health Endpoints** for all services
- **Google Cloud Logging** for centralized logs
- **Eureka Dashboard** for service monitoring
- **Automated Health Checks** via monitoring script

---

## 🤝 **Contributing**

### **Development Workflow**
1. Fork the repository
2. Create feature branch: `git checkout -b feature/new-feature`
3. Make changes and test locally
4. Build and test: `mvn clean test`
5. Deploy to test environment
6. Submit pull request

### **Code Standards**
- **Java 17** features and best practices
- **Spring Boot** conventions
- **RESTful API** design
- **Comprehensive error handling**
- **Health check endpoints** for all services

---

## 📞 **Support & Contact**

### **Quick Help**
- **Health Issues**: Run `./monitor-services.sh`
- **Deployment Issues**: Check Google Cloud Console logs
- **API Testing**: Use provided Postman collection
- **Local Development**: Ensure Java 17 and Maven are installed

### **Resources**
- **Eureka Dashboard**: https://eureka-service-692654636538.us-central1.run.app
- **Google Cloud Console**: https://console.cloud.google.com
- **MongoDB Atlas**: https://cloud.mongodb.com

---

**🎉 Project Status: ✅ PRODUCTION READY**  
**Last Updated**: October 2025  
**Version**: 1.0.0  
**Cloud Provider**: Google Cloud Platform  
**Database**: MongoDB Atlas  
**All services are live and operational!** 🚀