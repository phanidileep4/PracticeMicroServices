FROM openjdk:17-jdk-slim

WORKDIR /app

COPY target/userinfo-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 9098

ENTRYPOINT ["java", "-jar", "app.jar"]