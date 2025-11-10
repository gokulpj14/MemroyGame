# Use OpenJDK with GUI support
# Use OpenJDK with GUI support (still based on buster)
FROM openjdk:17-jdk-slim-buster

# Optional: second FROM is redundant — keep only one base image
# FROM debian:buster-slim

ENV DISPLAY=:0.0
ENV JAVA_TOOL_OPTIONS="-Djava.awt.headless=true"

# --- Fix old Debian repositories ---
RUN sed -i 's|deb.debian.org|archive.debian.org|g' /etc/apt/sources.list && \
    sed -i '/security.debian.org/s/^/#/' /etc/apt/sources.list && \
    echo "Acquire::Check-Valid-Until false;" > /etc/apt/apt.conf.d/99no-check-valid-until && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        fontconfig \
        ttf-dejavu && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /javaapp

# Copy source files
COPY src/* .

# Compile Java files
RUN javac MatchCards.java -d .
RUN javac App.java -d .

# Run the application (GUI mode)
CMD ["java", "-Djava.awt.headless=false", "App"]
