ARG BESU_VERSION
FROM --platform=linux/amd64 hyperledger/besu:${BESU_VERSION}

USER root
RUN apt-get update && \
    apt-get install --no-install-recommends -q --assume-yes \
    bash \
    ca-certificates \
    nginx \
    openssl \
    supervisor \
    vim-tiny \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set up nginx config
RUN mkdir -p /etc/nginx/certs/
WORKDIR /etc/nginx/certs/
ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
RUN wget http://iso.ava.do/my.ava.do.crt && wget http://iso.ava.do/my.ava.do.key

RUN ls -l /etc/nginx/certs/
COPY files/nginx.conf /etc/nginx
RUN mkdir -p /run/nginx

COPY ./files/supervisord.conf /etc/supervisord.conf

# Startup script
COPY ./files/start.sh /opt/start.sh
COPY ./files/reload-certs.sh /opt/reload-certs.sh
RUN chmod +x /opt/start.sh /opt/reload-certs.sh

ENTRYPOINT ["/opt/start.sh"]