# syntax=docker/dockerfile:1
FROM openjdk:alpine  AS build
RUN  apk update && \
     apk upgrade
RUN apk add zip
COPY . /usr/src/resume-1_5_1
WORKDIR /usr/src/resume-1_5_1/src
