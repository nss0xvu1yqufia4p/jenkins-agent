ARG version=4.7-1-jdk11
FROM jenkins/agent:$version

ARG version
LABEL Description="This is a base image, which allows connecting Jenkins agents via JNLP protocols" Vendor="Jenkins project" Version="$version"

ARG user=jenkins

USER root
RUN apt-get update -y && apt-get install -y curl sudo
RUN curl -sSL https://get.docker.com/ | sh
RUN usermod -aG docker ${user}
COPY jenkins-agent /usr/local/bin/jenkins-agent
RUN chmod +x /usr/local/bin/jenkins-agent &&\
    ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin
RUN echo $(stat -c %g /var/run/docker.sock)
USER ${user}

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
