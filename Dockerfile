FROM centos:7

LABEL maintainer="Vani Paridhyani"

RUN yum makecache fast \
 && yum -y install epel-release \
 && yum -y update \
 && yum -y install \
      sudo \
      telnet \
      curl \
      bash \
      git \
      python \
      python-pip \
 && yum clean all \
 && pip install --upgrade pip \
 && pip install ansible

