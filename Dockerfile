ARG version=4.7-1-jdk11
FROM jenkins/agent:$version

ARG version
LABEL Description="This is a base image, which allows connecting Jenkins agents via JNLP protocols" Vendor="Jenkins project" Version="$version"

ARG user=jenkins

USER root
RUN apt-get update -y && apt-get install -y curl sudo
RUN curl -sSL https://get.docker.com/ | sh
RUN usermod -aG docker ${user}
RUN chown ${user} /var/run/docker.sock
COPY jenkins-agent /usr/local/bin/jenkins-agent
RUN chmod +x /usr/local/bin/jenkins-agent &&\
    ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave
USER ${user}

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
