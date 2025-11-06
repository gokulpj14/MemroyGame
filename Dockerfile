# Use OpenJDK with GUI support
FROM openjdk:17-jdk-slim-buster
FROM debian:buster-slim
ENV DISPLAY=:0.0

ENV JAVA_TOOL_OPTIONS="-Djava.awt.headless=true"

# Install required fonts (if your application uses specific fonts for rendering)
RUN apt-get update && apt-get install -y --no-install-recommends \
    fontconfig \
    ttf-dejavu \
    && rm -rf /var/lib/apt/lists/*
# Set working directory
WORKDIR /javaapp

# Copy everything into container
COPY src/* .

# RUN cd /javaapp

# Compile the Java source file inside src/
RUN javac MatchCards.java -d .
RUN javac App.java -d .
# RUN javac HelloWorld.java

# Run the class (now in the default package) 
CMD ["java", "-Djava.awt.headless=false", "App"]
