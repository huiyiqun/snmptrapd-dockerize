FROM debian:latest

# Enable non-free
RUN sed -i -e 's/$/ contrib non-free/g' /etc/apt/sources.list && \
    sed -i -e 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
    sed -i -e 's/security.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list


RUN apt-get update && apt-get install -y libsnmp-dev snmp-mibs-downloader snmptrapd

RUN echo "sqlMaxQueue 140" >> /etc/snmp/snmptrapd.conf && \
    echo "sqlSaveInterval 9" >> /etc/snmp/snmptrapd.conf

RUN rm -rf /etc/mysql

ENV MY_CNF /etc/my.cnf
ENV SNMPTRAPD_COMMUNITY public
ENV SNMPTRAPD_DB_USER user
ENV SNMPTRAPD_DB_PASS secret
ENV SNMPTRAPD_DB_HOST localhost

CMD echo "authCommunity log $SNMPTRAPD_COMMUNITY" >> /etc/snmp/snmptrapd.conf && \
    echo "[snmptrapd]" >> $MY_CNF && \
    echo "user=$SNMPTRAPD_DB_USER" >> $MY_CNF && \
    echo "password=$SNMPTRAPD_DB_PASS" >> $MY_CNF && \
    echo "host=$SNMPTRAPD_DB_HOST" >> $MY_CNF && \
    echo "dummy=" >> $MY_CNF && \
    snmptrapd -Lo -f
