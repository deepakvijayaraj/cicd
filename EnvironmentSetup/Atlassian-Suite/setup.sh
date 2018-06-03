#!/bin/bash
# Script to setup most of the Atlassian suite tools including
# - Bitbucket Server
# - Confluence Server
# - Bamboo Server
# - Bamboo Agent
#
# Maintainer: deepakvijayaraj@gmail.com
# 
#################################
# Setup Bitbucket Server v5.11.1
#################################

mkdir -p Bitbucket/data
docker run -v $PWD/Bitbucket/data:/var/atlassian/application-data/bitbucket --name="bitbucket" -d -p 7990:7990 -p 7999:7999 atlassian/bitbucket-server

# Access bitbucket server on http://localhost:7990

#################################
# Setup Confluence Server v6.9.0
#################################

mkdir -p Confluence/data
docker run -v $PWD/Confluence/data:/var/atlassian/application-data/confluence --name="confluence" -d -p 8090:8090 -p 8091:8091 atlassian/confluence-server

#################################
# Setup Bamboo Server v6.5.0
#################################

docker build -t bambooserver:latest .
mkdir -p bamboo/server/data
docker run -v $PWD/bamboo/server/data:/home/bamboo/bamboo-home --name="bamboo-server" -d -p 8085:8085 bambooserver:latest

#################################
# Setup Bamboo Agent v5.6.1
#################################
bamboo_server_ip=`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' bamboo-server`

docker run -e HOME=/home/bamboo -e BAMBOO_SERVER=http://$bamboo_server_ip:8085/bamboo -i -t atlassian/bamboo-base-agent:5.6.1
