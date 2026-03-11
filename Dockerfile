FROM registry.redhat.io/ubi9/openjdk-21-runtime:1.24-2.1771324986

COPY /workspace/source/target/spring-petclinic-2.7.3.jar /deployments/

# EXPOSE 8080
# CMD ["java", "-jar", "/app/my-spring-boot-app.jar"]