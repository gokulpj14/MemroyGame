# Use OpenJDK with GUI support (Debian Bullseye)
FROM openjdk:17-jdk-slim-bullseye

ENV DISPLAY=:0.0
ENV JAVA_TOOL_OPTIONS="-Djava.awt.headless=true"

# Install required fonts
RUN apt-get update && apt-get install -y --no-install-recommends \
    fontconfig \
    ttf-dejavu \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /javaapp

COPY src/* .

RUN javac MatchCards.java -d .
RUN javac App.java -d .

CMD ["java", "-Djava.awt.headless=false", "App"]
