FROM ubuntu

RUN apt-get update \
    && apt-get install -y curl git uuid-runtime jq

RUN adduser --disabled-password --gecos '' stk
RUN uuid=$(uuidgen) \
&& echo ${uuid} > /etc/machine-id
USER root

WORKDIR /github/home

ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONIOENCODING utf-8
ENV GIT_SSL_NO_VERIFY 1

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]


