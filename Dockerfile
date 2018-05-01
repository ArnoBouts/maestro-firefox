FROM debian



ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
        xserver-xorg-core \
        ratpoison \
        xcompmgr \
    && apt-get clean

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
        libc6 \
        libfuse2 \
        libjpeg62-turbo \
        libopus0 \
        libpam0g \
        libssl1.1 \
        libx11-6 \
        libxfixes3 \
        libxrandr2 \
        git \
        autoconf \
        libtool \
        pkg-config \
        gcc \
        g++ \
        make  \
        libssl-dev \
        libpam0g-dev \
        libjpeg-dev \
        libx11-dev \
        libxfixes-dev \
        libxrandr-dev \
        flex \
        bison \
        libxml2-dev \
        intltool \
        xsltproc \
        xutils-dev \
        python-libxml2 \
        xutils \
        libfuse-dev \
        libmp3lame-dev \
        nasm \
        libpixman-1-dev \
        xserver-xorg-dev \
        pulseaudio \
    && cd /tmp \
    && git clone --recursive https://github.com/neutrinolabs/xrdp.git \
    && cd xrdp \
    && ./bootstrap \
    && ./configure \
    && make \
    && make install \
    && ln -s /usr/local/sbin/xrdp{,-sesman} /usr/sbin \
    && cp /etc/xrdp/xrdp.sh /etc/init.d/ \
    && cd / \
    && rm -rf /tmp/xrdp \
    && cd /tmp \
    && git clone --recursive https://github.com/neutrinolabs/xorgxrdp.git \
    && cd xorgxrdp \
    && ./bootstrap \
    && ./configure \
    && make \
    && make install \
    && cd / \
    && rm -rf /tmp/xorgxrdp \
    && apt-get autoremove --yes \
        git \
        autoconf \
        libtool \
        pkg-config \
        gcc \
        g++ \
        make  \
        libssl-dev \
        libpam0g-dev \
        libjpeg-dev \
        libx11-dev \
        libxfixes-dev \
        libxrandr-dev \
        flex \
        bison \
        libxml2-dev \
        intltool \
        xsltproc \
        xutils-dev \
        python-libxml2 \
        xutils \
        libfuse-dev \
        libmp3lame-dev \
        nasm \
        libpixman-1-dev \
        xserver-xorg-dev \
    && apt-get clean

# firefox installation
# FIREFOX_VERSION 59.0.3
RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
        wget \
        curl \
        bzip2 \
        libdbus-glib-1-2 \
        libgtk-3-0 \
    && curl -L "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=fr" | tar -jx -C "/opt" \
    && ln -s /opt/firefox/firefox /usr/bin/firefox \
    && apt-get autoremove --yes \
        curl \
        bzip2 \
    && apt-get clean

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
        libasound2 \
        libatk1.0-0 \
        libc6 \
        libcairo-gobject2 \
        libcairo2 \
        libdbus-1-3 \
        libdbus-glib-1-2 \
        libevent-2.0-5 \
        libffi6 \
        libfontconfig1 \
        libfreetype6 \
        libgcc1 \
        libgdk-pixbuf2.0-0 \
        libglib2.0-0 \
        libgtk-3-0 \
        libgtk2.0-0 \
        libhunspell-1.4-0 \
        libjsoncpp1 \
        libpango-1.0-0 \
        libstartup-notification0 \
        libstdc++6 \
        libvpx4 \
        libx11-6 \
        libx11-xcb1 \
        libxcb-shm0 \
        libxcb1 \
        libxcomposite1 \
        libxdamage1 \
        libxext6 \
        libxfixes3 \
        libxrender1 \
        libxt6 \
        zlib1g \
        fontconfig \
        procps \
        debianutils \
        libsqlite3-0 \
    && apt-get clean

RUN apt-get update && apt-get install --yes --no-install-recommends libpam-ldapd libnss-ldapd && apt-get clean

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

COPY profiles.ini /root/.mozilla/firefox/profiles.ini
VOLUME /home

COPY .xsession /etc/skel/.xsessionrc
COPY .ratpoisonrc /etc/skel/.ratpoisonrc
COPY profiles.ini /etc/skel/.mozilla/firefox/profiles.ini
RUN mkdir -p /etc/skel/.mozilla/firefox/profile.default

COPY pam_ldap.conf /etc/pam_ldap.conf
COPY ldap.conf /etc/ldap.conf
COPY nslcd.conf /etc/nslcd.conf
RUN chmod 600 /etc/nslcd.conf
COPY mkhomedir /usr/share/pam-configs/mkhomedir
