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

ARG S6_OVERLAY_VERSION="v3.1.3.0"
RUN wget "https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz" -O "/tmp/s6-overlay-noarch.tar.xz" && \
    tar -C / -Jxpf "/tmp/s6-overlay-noarch.tar.xz" && \
    rm -f "/tmp/s6-overlay-noarch.tar.xz"

RUN [ "${TARGETARCH}" == "arm64" ] && FILE="s6-overlay-aarch64.tar.xz" || FILE="s6-overlay-x86_64.tar.xz"; \
    wget "https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/${FILE}" -O "/tmp/${FILE}" && \
    tar -C / -Jxpf "/tmp/${FILE}" && \
    rm -f "/tmp/${FILE}"

COPY ./services.d /etc/services.d
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY ./Caddyfile /etc/caddy/Caddyfile 
EXPOSE 80
ENTRYPOINT ["/init"]


