FROM ubuntu:bionic AS builder
RUN apt-get update && apt-get install -y curl
WORKDIR /root
RUN curl https://tmc-cli.s3-us-west-2.amazonaws.com/tmc/0.2.1-7e9c62fc/linux/x64/tmc -o /root/tmc
RUN chmod +x /root/tmc

FROM python:3
WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y jq git curl
COPY --from=builder /root/tmc /usr/local/bin/tmc
RUN chmod +x /usr/local/bin/tmc

ENV TMC_API_TOKEN XXXXX

ADD apply.sh /usr/src/app
ADD cluster_patch_yaml.py /usr/src/app
RUN chmod +x /usr/src/app/*

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]


