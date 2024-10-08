# Use an argument to specify the Alpine version for flexibility
ARG ALPINE_VERSION=3.20.3
ARG MINECRAFT_VERSION=1.21.1

# Base stage with Alpine
FROM alpine:${ALPINE_VERSION} AS base

# Install OpenJDK and other necessary packages in the base image
RUN apk add --no-cache openjdk21-jre-headless udev

# Build stage for downloading Minecraft server jar
FROM base AS build

WORKDIR /opt/minecraft-server

# Download Minecraft server jar and clean up
RUN apk add --no-cache wget && \
    wget https://piston-data.mojang.com/v1/objects/59353fb40c36d304f2035d51e7d6e6baa98dc05c/server.jar -O minecraft_server.${MINECRAFT_VERSION}.jar && \
    apk del wget

# Final stage for running the server
FROM base AS final

# Set the working directory
WORKDIR /opt/minecraft-server

# Copy the Minecraft server jar from the build stage
COPY --from=build /opt/minecraft-server/minecraft_server.${MINECRAFT_VERSION}.jar /opt/minecraft-server/minecraft_server.${MINECRAFT_VERSION}.jar

# Copy the EULA file
COPY ./eula.txt /opt/minecraft-server/eula.txt

# Expose necessary ports
EXPOSE 25565

# Create a non-root user and switch to that user for security purposes
RUN adduser -D -H -u 1001 minecraft && \
    chown -R minecraft /opt/minecraft-server

# Switch to non-root user
USER minecraft

# Default command to run the Minecraft server
CMD ["/usr/bin/java", "-Xmx1024M", "-Xms1024M", "-jar", "/opt/minecraft-server/minecraft_server.${MINECRAFT_VERSION}.jar", "nogui"]
