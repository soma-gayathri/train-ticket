FROM eclipse-temurin:17-jdk AS build
WORKDIR /workspace
COPY backend ./backend
COPY db ./db
COPY docs ./docs
WORKDIR /workspace/backend
RUN chmod +x mvnw && ./mvnw -B -DskipTests package

FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /workspace/backend/target/railway-api-0.0.1-SNAPSHOT.jar app.jar
RUN mkdir -p /app/data && chown -R 10001:10001 /app/data
ENV SERVER_ADDRESS=0.0.0.0
EXPOSE 8080
USER 10001
ENTRYPOINT ["java","-jar","app.jar"]
