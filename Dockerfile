FROM ubuntu:24.04

RUN apt update &&\
    apt install software-properties-common -y &&\
    add-apt-repository ppa:lely/ppa -y &&\
    apt update &&\
    apt install net-tools iproute2 can-utils kmod liblely-coapp-dev liblely-co-tools python3-dcf-tools -y

ADD docker-entrypoint.sh .

ENTRYPOINT ["sh", "docker-entrypoint.sh"]
