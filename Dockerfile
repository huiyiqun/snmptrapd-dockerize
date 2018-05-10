FROM debian:latest

# Enable non-free
RUN sed -i -e 's/$/ contrib non-free/g' /etc/apt/sources.list && \
    sed -i -e 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
    sed -i -e 's/security.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list


RUN apt-get update && apt-get install -y libsnmp-dev snmp-mibs-downloader

RUN apt-get install -y snmptrapd

ENV SNMPTRAPD_COMMUNITY public
ENV SNMPTRAPD_OUTPUT_FILE /data/snmptrapd.log

CMD echo "authCommunity log $SNMPTRAPD_COMMUNITY" >> /etc/snmp/snmptrapd.conf && snmptrapd -Lf "$SNMPTRAPD_OUTPUT_FILE" -f
