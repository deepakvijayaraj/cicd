#!/bin/sh
# Pre-Requisites
# VirtualBox >=  5.2.12
# Docker >= 18.03.1-ce
# This script tested on Mac OS 10.13.4
mkdir /tmp/environment

cd /tmp/environment

################################################################
#Setup GitHub Enterprise 2.13.3 as VirtualBox VM
################################################################
if [ ! -f github-enterprise-2.13.3.ova ]
then
  curl -O https://github-enterprise.s3.amazonaws.com/esx/releases/github-enterprise-2.13.3.ova
fi

# Use vboxmanage to setup the machine
VM="GitHub Enterprise"
VBoxManage import github-enterprise-2.13.3.ova

VBoxManage createhd --filename github-enterprise --size 10240
VBoxManage storageattach "$VM" --storagectl "SAS" --port 1 --device 0 --type hdd --medium github-enterprise.vdi
VBoxManage startvm "$VM" --type headless

###########################################
# Setup Teamcity Enterprise Server v5.11.1
############################################
# Download and install Teamcity Server and Agent as Docker instances

mkdir -p tce/datadir
mkdir -p tce/logs
mkdir -p tce/agent/conf

docker rm -f teamcity-server-instance teamcity-agent-instance

docker run -d -it --name teamcity-server-instance  \
    -v $PWD/tce/datadir:/data/teamcity_server/datadir \
    -v $PWD/tce/logs:/opt/teamcity/logs  \
    -p 8111:8111 \
    jetbrains/teamcity-server

tce_server_ip=`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' teamcity-server-instance`

docker run -d -it -e SERVER_URL="http://$tce_server_ip:8111"  \
    --name teamcity-agent-instance \
    -v $PWD/tce/agent/conf:/data/teamcity_agent/conf  \
    jetbrains/teamcity-agent
