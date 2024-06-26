Use Jenkins official image
FROM jenkins/jenkins:lts

USER root

RUN apt-get update && apt-get install -y sudo

RUN curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh

RUN usermod -aG docker jenkins

RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER jenkins