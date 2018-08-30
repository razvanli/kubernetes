#FROM haproxy:1.7

#RUN groupadd haproxy && useradd -g haproxy haproxy

#COPY haproxy.cfg /etc/haproxy/haproxy.cfg
#
#CMD touch /var/log/haproxy.log && chmod 777 /var/log/haproxy.log
#
#CMD service rsyslog start && service haproxy start && aproxy -f /etc/haproxy/haproxy.cfg
#
FROM ubuntu:16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
  bash curl socat haproxy ca-certificates liblua5.3-0 && \
  apt-get clean -y && \
  rm -rf /var/lib/apt/lists/* /tmp/*

RUN mkdir -p /etc/haproxy/errors /var/state/haproxy
RUN for ERROR_CODE in 400 403 404 408 500 502 503 504;do curl -sSL -o /etc/haproxy/errors/$ERROR_CODE.http \
	https://raw.githubusercontent.com/haproxy/haproxy-1.5/master/examples/errorfiles/$ERROR_CODE.http;done

ADD haproxy.cfg /etc/haproxy/haproxy.cfg

CMD ["/usr/sbin/haproxy", "-db", "-f", "/etc/haproxy/haproxy.cfg"]
