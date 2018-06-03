FROM ubuntu:16.04
MAINTAINER "deepakvijayaraj@gmail.com"

ARG bamboo_link="https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-6.5.0.tar.gz"
EXPOSE 8085

RUN apt-get update && apt-get install -y sudo wget curl vim openjdk-8-jdk && rm -rf /var/lib/apt/lists/*

RUN adduser --disabled-password --gecos '' bamboo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER bamboo
RUN mkdir /home/bamboo/installation /home/bamboo/bamboo-home && cd /home/bamboo

RUN wget -O /home/bamboo/atlassian-bamboo.tar.gz $bamboo_link

RUN tar -xvzf /home/bamboo/atlassian-bamboo.tar.gz -C /home/bamboo/installation --strip-components=1
RUN echo "bamboo.home=/home/bamboo/bamboo-home" >> /home/bamboo/installation/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties
RUN export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

CMD ["cd /home/bamboo/installation && bin/start-bamboo.sh"]
