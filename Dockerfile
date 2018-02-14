FROM ubuntu:16.04 as ipxe-build

RUN bash -exc '\
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
        build-essential \
        genisoimage \
        git \
        liblzma-dev && \
    git clone http://git.ipxe.org/ipxe.git /root/ipxe && \
    cd /root/ipxe/src && \
    make bin/{undionly,ipxe}.{,k,kk}pxe'

FROM quay.io/coreos/dnsmasq:latest

COPY --from=ipxe-build /root/ipxe/src/bin/*pxe /var/lib/tftpboot/
