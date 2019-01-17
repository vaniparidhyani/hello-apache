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
      sshpass \
      PyYAML \
      python \
      python-pip \
      python-paramiko \
      python-jinja2 \
      python-setuptools \ 
 && yum clean all \
 && pip install --upgrade pip \
 && pip install ansible

#COPY vault_pass /etc/ansible/.vault_pass
#COPY git.yml /etc/ansible/git.yml
COPY gittoken /etc/ansible/gittoken

ENV ANSIBLE_TRANSPORT local
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_STDOUT_CALLBACK default
#ENV ANSIBLE_REMOTE_USER wcmcmd
ENV ANSIBLE_HASH_BEHAVIOUR merge
ENV ANSIBLE_PRIVATE_KEY_FILE id_rsa
#ENV ANSIBLE_VAULT_PASSWORD_FILE /etc/ansible/.vault_pass
ENV ANSIBLE_BECOME true
ENV ANSIBLE_PTY false
ENV ANSIBLE_SSH_ARGS -C -o ControlMaster=auto -o ControlPersist=600s
ENV ANSIBLE_TRANSFER_METHOD scp
ENV ANSIBLE_CONNECT_TIMEOUT 30
ENV ANSIBLE_CONNECT_RETRIES 30
ENV ANSIBLE_CONNECT_INTERVAL 1
ENV ANSIBLE_FORCE_COLOR true

ENV ANSIBLE_RETRY_FILES_ENABLED false

ENV BRANCH master
ENV ANSIBLEAUTHOR false
ENV ANSIBLEHAPROXY false
ENV ANSIBLEPUBLISH true
ENV ANSIBLEHTTPD true
ENV ANSIBLELOC false
ENV ANSIBLEINTERNAL false
ENV PROJECTID helloapache

#WORKDIR /etc/ansible

#RUN gittoken=`ansible-vault view /etc/ansible/git.yml --vault-password-file /etc/ansible/.vault_pass`
RUN gittoken=`cat /etc/ansible/gittoken`
RUN rm -rf /etc/ansible
RUN git clone --branch $BRANCH --single-branch https://$gittoken@github.com/vaniparidhyani/hello-apache.git /etc/ansible/

RUN mkdir /etc/ansible/facts.d
RUN printf "[install]\nauthor=$ANSIBLEAUTHOR\nhaproxy=$ANSIBLEHAPROXY\npublish=$ANSIBLEPUBLISH\nwebserver=$ANSIBLEHTTPD\nloc=$ANSIBLELOC\ninternal=$ANSIBLEINTERNAL" > /etc/ansible/facts.d/wcms.fact

RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

EXPOSE 80

ENTRYPOINT ["ansible-playbook -vv /etc/ansible/$PROJECTID.yml -i /etc/ansible/hosts"]
