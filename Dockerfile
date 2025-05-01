# 使用 Maven 作為 build 階段
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# 使用 JRE 作為運行階段
FROM eclipse-temurin:21-jre
WORKDIR /app哈哈
COPY --from=build /app/target/Cloud-Native-HW4-1.0-SNAPSHOT.jar app.jar

# 指定啟動命令
ENTRYPOINT ["java", "-jar", "app.jar"]
