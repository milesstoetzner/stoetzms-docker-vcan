FROM ubuntu:24.04

RUN apt-get update &&\
    apt-get install software-properties-common -y &&\
    add-apt-repository ppa:lely/ppa -y &&\
    apt-get update &&\
    apt-get install iproute2 can-utils liblely-co-tools -y &&\
    rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh .

ENTRYPOINT ["sh", "docker-entrypoint.sh"]
