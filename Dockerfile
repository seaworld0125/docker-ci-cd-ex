FROM openjdk:11-jre as base

FROM base as test
RUN ["./gradlew", "test"]

COPY build/libs/demo-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]