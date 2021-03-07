FROM jenkins/jnlp-slave:3.27-1
USER root
ENV DEBIAN_FRONTEND noninteractive
RUN cat /etc/issue
RUN cat /etc/apt/sources.list | grep -v security > /etc/apt/sources.list_clean && cp /etc/apt/sources.list_clean /etc/apt/sources.list
RUN apt-get update  -y
RUN apt-get install -y git wget curl nano unzip sudo vim net-tools software-properties-common haveged apt-transport-https mariadb-client telnet
RUN apt-get install -y netcat
RUN apt-get install -y iputils-ping



RUN sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
RUN sudo apt-get remove docker docker-engine docker.io


RUN sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
RUN sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

RUN sudo apt-get update -y
RUN sudo apt-get install -y docker-ce docker-ce-cli kubectl containerd.io
RUN adduser jenkins sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


USER jenkins
RUN sudo apt-get install -y uidmap libseccomp-dev make build-essential pkg-config go-bindata

RUN wget https://dl.google.com/go/go1.11.linux-amd64.tar.gz && \
        sudo tar -xvf go1.11.linux-amd64.tar.gz && \
        sudo mv go /usr/local

RUN echo $HOME

ENV GOROOT /usr/local/go
ENV GOPATH /var/go
ENV PATH $GOPATH/bin:$GOROOT/bin:$PATH

RUN sudo mkdir /var/go && sudo chown -R jenkins:jenkins /var/go

RUN git clone https://github.com/genuinetools/img $GOPATH/src/github.com/genuinetools/img
RUN cd $GOPATH/src/github.com/genuinetools/img && make && make install
RUN sudo ln -s /var/go/bin/img /usr/local/bin/img
