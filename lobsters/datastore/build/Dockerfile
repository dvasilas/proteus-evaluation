FROM mysql AS stage0
WORKDIR /usr/local/
RUN set -xe && \
    apt-get update -y && \
    apt-get install -y build-essential libmysqlclient-dev wget python iproute2 && \
    wget https://dl.google.com/go/go1.14.2.linux-amd64.tar.gz && \
    tar -xzf go1.14.2.linux-amd64.tar.gz && \
    rm go1.14.2.linux-amd64.tar.gz && \
    ln -s /opt/go go

FROM stage0 as stage1
COPY proteus-lobsters /opt/proteus-lobsters/
COPY delay.sh /opt/
WORKDIR /opt/proteus-lobsters/
RUN set -xe && \
    /usr/local/bin/docker-entrypoint.sh && \
    make && \
    cp lib_sys_exec.so /usr/lib/mysql/plugin/ && \
    /usr/local/go/bin/go build server.go && \
    touch /opt/proteus-lobsters/server.log && chown -R mysql:mysql /opt/proteus-lobsters/server.log
