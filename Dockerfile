# Use an official OpenJDK 21 runtime as a parent image
FROM openjdk:21-jdk

# Set the working directory in the container
WORKDIR /app

# Copy the application JAR file to the container
COPY javaWebApp/target/javaWebApp-0.0.1-SNAPSHOT.jar /app/demo.jar

# Expose the port your application runs on
EXPOSE 8080

# Define the command to run the application
CMD ["java", "-jar", "/app/demo.jar"]