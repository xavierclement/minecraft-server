FROM alpine:3.20.3 AS base

FROM base

ARG MINECRAFT_VERSION
ARG MINECRAFT_SERVER_URL

LABEL maintainer="xavierclementantoine@protonmail.com"
LABEL description="Minecraft Server Docker Image"

RUN echo "Minecraft version: ${MINECRAFT_VERSION}"
RUN echo "Minecraft URL: ${MINECRAFT_URL}"

