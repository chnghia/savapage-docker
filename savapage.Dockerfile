FROM ubuntu:bionic
ENV SAVA_VERSION=1.2.0-rc
RUN apt-get update && \
    apt-get -y install cups cups-bsd poppler-utils qpdf imagemagick wget gnupg \
    software-properties-common avahi-daemon avahi-discover libnss-mdns \
    binutils wget curl supervisor openssh-server

RUN apt-get install cpio openjdk-11-jdk -y

RUN useradd -r savapage && \
    mkdir -p /opt/savapage && \
    usermod -s /bin/bash savapage && \
    usermod -d /opt/savapage savapage && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /run/sshd 

COPY config/cupsd.conf /etc/cups/cupsd.conf

COPY config/cups-browsed.conf /etc/cups/cups-browsed.conf

COPY config/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY config/papersize /etc/papersize

RUN mkdir -p /opt/savapage && cd /opt/savapage && \
    wget https://www.savapage.org/download/snapshots/savapage-setup-${SAVA_VERSION}-linux-x64.bin -O savapage-setup-linux.bin && \
    chown savapage:savapage /opt/savapage && \
    chmod +x savapage-setup-linux.bin

RUN su savapage sh -c "/opt/savapage/savapage-setup-linux.bin -n" && \
    /opt/savapage/MUST-RUN-AS-ROOT

CMD ["/usr/bin/supervisord"]

# CMD ["/bin/bash"]