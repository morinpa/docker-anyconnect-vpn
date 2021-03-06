FROM alpine:edge
MAINTAINER Wolfgang Klinger <wolfgang@wazum.com>

# Use an up-to-date version of vpnc-script
# https://www.infradead.org/openconnect/vpnc-script.html
COPY vpnc-script /etc/vpnc/vpnc-script

COPY entrypoint.sh /entrypoint.sh

COPY tinyproxy.conf /etc/tinyproxy.conf

RUN apk add --no-cache libcrypto1.1 libssl1.1 libstdc++ --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    && apk add --no-cache oath-toolkit-libpskc --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    && apk add --no-cache nettle --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    # openconnect is not yet available on main
    && apk add --no-cache openconnect tinyproxy --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    && apk add --no-cache ca-certificates wget \
    && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-2.30-r0.apk \
    && apk add --no-cache --virtual .build-deps glibc-2.30-r0.apk gcc make musl-dev \
    && cd /tmp \
    && wget https://github.com/rofl0r/microsocks/archive/v1.0.1.tar.gz \
    && tar -xzvf v1.0.1.tar.gz \
    && cd microsocks-1.0.1 \
    && make \
    && make install \
    # add vpn-slice with dependencies (dig) https://github.com/dlenski/vpn-slice
    && apk add --no-cache python3 bind-tools && pip3 install --upgrade pip \
    && pip3 install https://github.com/dlenski/vpn-slice/archive/master.zip \
    # always add the docker DNS server
    && grep -qxF 'nameserver 127.0.0.11' /etc/resolv.conf || echo 'nameserver 127.0.0.11' >> /etc/resolv.conf \
    && apk del .build-deps wget \
    && chmod 755 /etc/vpnc/vpnc-script \
    && chmod +x /entrypoint.sh

EXPOSE 8888
EXPOSE 8889

ENTRYPOINT ["/entrypoint.sh"]
