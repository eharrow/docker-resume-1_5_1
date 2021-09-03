# syntax=docker/dockerfile:1
FROM openjdk:slim-buster  AS build
RUN  apt-get update -y && \
     apt-get upgrade -y && \
     apt-get dist-upgrade -y && \
     apt-get -y autoremove && \
     apt-get clean
RUN apt-get -y install zip
COPY . /usr/src/resume-1_5_1
WORKDIR /usr/src/resume-1_5_1/src
