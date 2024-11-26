# This Dockerfile is used to build an image containing a node jenkins slave

FROM node:18

# Upgrade and Install packages
RUN apt-get update && apt-get -y upgrade && apt-get install -y git openssh-server && apt-get install -y ca-certificates-java openjdk-17-jdk jq
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install --no-install-recommends --assume-yes \
      docker.io

#Allow github push & pull
RUN ssh-keyscan -t rsa github.com >> /etc/ssh/ssh_known_hosts
RUN chmod 777 /etc/ssh/ssh_known_hosts

# Add user and group for jenkins
RUN groupadd -g 10000 jenkins
RUN useradd -m -u 10000 -g 10000 jenkins
RUN echo "jenkins:jenkins" | chpasswd

# Prepare container for ssh
RUN mkdir /var/run/sshd

ENV CI=true
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]