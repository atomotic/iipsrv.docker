FROM caddy as caddy
FROM debian:stable-slim
RUN apt update && apt install -y \
    build-essential git libtiff-dev autoconf libtool \
    pkg-config cmake libmemcached-dev xz-utils memcached \
    && rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/uclouvain/openjpeg /tmp/openjpeg; cd /tmp/openjpeg; cmake .; make; make install
RUN printf "include /etc/ld.so.conf.d/*.conf\ninclude /usr/local/lib\n" > /etc/ld.so.conf && ldconfig
RUN git clone https://github.com/ruven/iipsrv.git /tmp/iipsrv
WORKDIR /tmp/iipsrv
RUN ./autogen.sh && ./configure && make
WORKDIR /iipsrv
RUN cp /tmp/iipsrv/src/iipsrv.fcgi .
ADD https://github.com/just-containers/s6-overlay/releases/download/v3.1.2.1/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v3.1.2.1/s6-overlay-aarch64.tar.xz /tmp/
RUN tar -C / -Jxpf /tmp/s6-overlay-aarch64.tar.xz
COPY ./services.d /etc/services.d
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY ./Caddyfile /etc/caddy/Caddyfile 
EXPOSE 80
ENTRYPOINT ["/init"]


