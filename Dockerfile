FROM openjdk:slim
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
HEALTHCHECK NONE
ENTRYPOINT ["java","-jar","/app.jar"]
