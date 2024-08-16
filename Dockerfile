# Use an official OpenJDK 21 runtime as a parent image
FROM openjdk:21-jdk

#Default value for jar file path
ARG JAR_PATH=javaWebApp/target/javaWebApp-0.0.1-SNAPSHOT.jar

# Set the working directory in the container
WORKDIR /app

# Copy the application JAR file to the container
COPY $JAR_PATH /app/demo.jar

# Expose the port your application runs on
EXPOSE 8080

# Define the command to run the application
CMD ["java", "-jar", "/app/demo.jar"]