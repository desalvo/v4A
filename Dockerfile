FROM varnish
# FROM varnish:fresh-alpine

USER root

# alpine version
# RUN apk add --no-cache --upgrade curl bash net-snmp jq

# debian version
RUN apt-get update; apt-get -y install curl snmpd snmp jq vim python3 procps

RUN rm /usr/share/snmp/mibs/*
RUN mkdir -p /usr/share/snmp/mibs/squid

COPY default.vcl /etc/varnish/

COPY runme.sh /usr/local/bin/
COPY Monitoring/sender.sh /usr/local/bin/

COPY Monitoring/snmpd.conf /etc/snmp/
COPY Monitoring/snmp.conf /etc/snmp/

COPY mibs/* /usr/share/snmp/mibs/
COPY Monitoring/SQUID-MIB.txt /usr/share/snmp/mibs/squid/

COPY Monitoring/snmpd_sender.py /usr/local/bin/

ENV MIBS=ALL

ENV VARNISH_MEM=2000m
ENV VARNISH_TRANSIENT_MEM=2000m
ENV VARNISH_PORT=6082
ENV MONITOR_SNMP=false
ENV MONITOR_ES=true
ENV MONITOR_ES_ENDPOINTS=varnish.atlas-ml.org:80

EXPOSE 3401/udp

CMD [ "/usr/local/bin/runme.sh" ]
