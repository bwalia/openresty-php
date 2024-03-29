FROM php:8.1-fpm-alpine3.16

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && sync && install-php-extensions \
    gd \
    xdebug \
    @composer \
    intl \
    mcrypt \
    memcache \
    mysqli \
    xlswriter \
    uuid \
    zip \
    yaml \
    mailparse

ARG RESTY_IMAGE_BASE="alpine"
ARG RESTY_IMAGE_TAG="3.16"
# Docker Build Arguments
ARG RESTY_VERSION="1.21.4.1"
ARG RESTY_OPENSSL_VERSION="1.1.1i"
ARG RESTY_OPENSSL_PATCH_VERSION="1.1.1f"
ARG RESTY_OPENSSL_URL_BASE="https://www.openssl.org/source"
ARG RESTY_PCRE_VERSION="8.45"
ARG RESTY_J="1"
ARG RESTY_CONFIG_OPTIONS="\
    --with-compat \
    --with-file-aio \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_geoip_module=dynamic \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_image_filter_module=dynamic \
    --with-http_mp4_module \
    --with-http_random_index_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-http_xslt_module=dynamic \
    --with-ipv6 \
    --with-mail \
    --with-mail_ssl_module \
    --with-md5-asm \
    --with-pcre-jit \
    --with-sha1-asm \
    --with-stream \
    --with-stream_ssl_module \
    --with-threads \
    "
ARG RESTY_CONFIG_OPTIONS_MORE=""
ARG RESTY_LUAJIT_OPTIONS="--with-luajit-xcflags='-DLUAJIT_NUMMODE=2 -DLUAJIT_ENABLE_LUA52COMPAT'"

ARG RESTY_ADD_PACKAGE_BUILDDEPS=""
ARG RESTY_ADD_PACKAGE_RUNDEPS=""
ARG RESTY_EVAL_PRE_CONFIGURE=""
ARG RESTY_EVAL_POST_MAKE=""

RUN apk update && \
    apk add --no-cache --virtual \
    build-base \
    coreutils \
    curl \
    bash \
    gd-dev \
    geoip-dev \
    libxslt-dev \
    linux-headers \
    make \
    perl-dev \
    readline-dev \
    zlib-dev \
    gd \
    geoip \
    libgcc \
    libxslt \
    patch \
    zlib \
    vim \
    git \
    g++ 
    

RUN php -v

ARG SOURCES_DIR="/src"

RUN mkdir -p ${SOURCES_DIR} && cd ${SOURCES_DIR}

ARG PHP_SOCKET_DIR="/var/run/php-fpm"
ARG LOGS_DIR="/var/log/nginx"
RUN mkdir -p ${LOGS_DIR}

WORKDIR ${SOURCES_DIR}

RUN cd ${SOURCES_DIR} && wget https://openresty.org/download/openresty-${RESTY_VERSION}.tar.gz -O ${SOURCES_DIR}/openresty-${RESTY_VERSION}.tar.gz \
    && tar -zxvf ${SOURCES_DIR}/openresty-${RESTY_VERSION}.tar.gz
# \
#&& ls -la ${SOURCES_DIR}/openresty-${RESTY_VERSION}/patches/openssl-1.0.2h-sess_set_get_cb_yield.patch    

RUN cd ${SOURCES_DIR} && wget https://www.openssl.org/source/openssl-1.0.2k.tar.gz -O ${SOURCES_DIR}/openssl-1.0.2k.tar.gz \
    && tar -zvxf ${SOURCES_DIR}/openssl-1.0.2k.tar.gz \
    && cd ${SOURCES_DIR}/openssl-1.0.2k \
    && patch -p1 < ${SOURCES_DIR}/openresty-${RESTY_VERSION}/patches/openssl-1.0.2h-sess_set_get_cb_yield.patch
#     && ls -la ${SOURCES_DIR}/openresty-${RESTY_VERSION}/patches/openssl-1.0.2h-sess_set_get_cb_yield.patch

# These are not intended to be user-specified
ARG _RESTY_CONFIG_DEPS="--with-pcre \
    --with-cc-opt='-DNGX_LUA_ABORT_AT_PANIC -I/usr/local/openresty/pcre/include -I/usr/local/openresty/openssl/include' \
    --with-ld-opt='-L/usr/local/openresty/pcre/lib -L/usr/local/openresty/openssl/lib -Wl,-rpath,/usr/local/openresty/pcre/lib:/usr/local/openresty/openssl/lib' \
    "

LABEL resty_image_base="${RESTY_IMAGE_BASE}"
LABEL resty_image_tag="${RESTY_IMAGE_TAG}"
LABEL resty_version="${RESTY_VERSION}"
LABEL resty_openssl_version="${RESTY_OPENSSL_VERSION}"
LABEL resty_openssl_patch_version="${RESTY_OPENSSL_PATCH_VERSION}"
LABEL resty_openssl_url_base="${RESTY_OPENSSL_URL_BASE}"
LABEL resty_pcre_version="${RESTY_PCRE_VERSION}"
LABEL resty_config_options="${RESTY_CONFIG_OPTIONS}"
LABEL resty_config_options_more="${RESTY_CONFIG_OPTIONS_MORE}"
LABEL resty_config_deps="${_RESTY_CONFIG_DEPS}"
LABEL resty_add_package_builddeps="${RESTY_ADD_PACKAGE_BUILDDEPS}"
LABEL resty_add_package_rundeps="${RESTY_ADD_PACKAGE_RUNDEPS}"
LABEL resty_eval_pre_configure="${RESTY_EVAL_PRE_CONFIGURE}"
LABEL resty_eval_post_make="${RESTY_EVAL_POST_MAKE}"

RUN cd ${SOURCES_DIR} \
    && curl -fSL https://edgeone-public.s3.eu-west-2.amazonaws.com${SOURCES_DIR}/pcre/pcre-${RESTY_PCRE_VERSION}.tar.gz -o ${SOURCES_DIR}/pcre-${RESTY_PCRE_VERSION}.tar.gz \
    && tar xzf ${SOURCES_DIR}/pcre-${RESTY_PCRE_VERSION}.tar.gz \
    && cd ${SOURCES_DIR}/pcre-${RESTY_PCRE_VERSION} \
    && ./configure \
    --prefix=/usr/local/openresty/pcre \
    --disable-cpp \
    --enable-jit \
    --enable-utf \
    --enable-unicode-properties \
    && make -j${RESTY_J} \
    && make -j${RESTY_J} install

RUN cd ${SOURCES_DIR} \
    && curl -fSL "${RESTY_OPENSSL_URL_BASE}/openssl-${RESTY_OPENSSL_VERSION}.tar.gz" -o ${SOURCES_DIR}/openssl-${RESTY_OPENSSL_VERSION}.tar.gz \
    && tar xzf ${SOURCES_DIR}/openssl-${RESTY_OPENSSL_VERSION}.tar.gz \
    && cd ${SOURCES_DIR}/openssl-${RESTY_OPENSSL_VERSION} \
    && if [ $(echo ${RESTY_OPENSSL_VERSION} | cut -c 1-5) = "1.1.1" ] ; then \
    echo 'patching OpenSSL 1.1.1 for OpenResty' \
    && curl -s https://raw.githubusercontent.com/openresty/openresty/master/patches/openssl-${RESTY_OPENSSL_PATCH_VERSION}-sess_set_get_cb_yield.patch | patch -p1 ; \
    fi \
    && if [ $(echo ${RESTY_OPENSSL_VERSION} | cut -c 1-5) = "1.1.0" ] ; then \
    echo 'patching OpenSSL 1.1.0 for OpenResty' \
    && curl -s https://raw.githubusercontent.com/openresty/openresty/ed328977028c3ec3033bc25873ee360056e247cd/patches/openssl-1.1.0j-parallel_build_fix.patch | patch -p1 \
    && curl -s https://raw.githubusercontent.com/openresty/openresty/master/patches/openssl-${RESTY_OPENSSL_PATCH_VERSION}-sess_set_get_cb_yield.patch | patch -p1 ; \
    fi \
    && ./config \
    no-threads shared zlib -g \
    enable-ssl3 enable-ssl3-method \
    --prefix=/usr/local/openresty/openssl \
    --libdir=lib \
    -Wl,-rpath,/usr/local/openresty/openssl/lib \
    && make -j${RESTY_J} \
    && make -j${RESTY_J} install_sw

    RUN cd ${SOURCES_DIR} \
    && curl -fSL https://openresty.org/download/openresty-${RESTY_VERSION}.tar.gz -o ${SOURCES_DIR}/openresty-${RESTY_VERSION}.tar.gz \
    && tar xzf ${SOURCES_DIR}/openresty-${RESTY_VERSION}.tar.gz \
    && cd ${SOURCES_DIR}/openresty-${RESTY_VERSION} \
    && eval ./configure -j${RESTY_J} ${_RESTY_CONFIG_DEPS} ${RESTY_CONFIG_OPTIONS} ${RESTY_CONFIG_OPTIONS_MORE} ${RESTY_LUAJIT_OPTIONS} \
    && make -j${RESTY_J} \
    && make -j${RESTY_J} install \
    && cd ${SOURCES_DIR} \
    && if [ -n "${RESTY_EVAL_POST_MAKE}" ]; then eval $(echo ${RESTY_EVAL_POST_MAKE}); fi \
#    && apk del .build-deps \
    && mkdir -p /var/run/openresty \
    && mkdir -p ${PHP_SOCKET_DIR} \
    && ln -sf /dev/stdout ${LOGS_DIR}/access.log \
    && ln -sf /dev/stderr ${LOGS_DIR}/error.log
# Reset permissions for php unix sockets.
RUN chown www-data:www-data ${PHP_SOCKET_DIR}
RUN chmod +x ${PHP_SOCKET_DIR}
RUN chmod 777 -R ${PHP_SOCKET_DIR}
RUN rm -rf ${SOURCES_DIR}

# Add additional binaries into PATH for convenience
ENV PATH=$PATH:/usr/local/openresty/luajit/bin:/usr/local/openresty/nginx/sbin:/usr/local/openresty/bin

RUN /usr/local/openresty/bin/openresty -V
# Unix socket is not working yet

RUN sed -i "s|listen = 9000|listen = /var/run/php-fpm/php8-fpm.sock|g" /usr/local/etc/php-fpm.d/zz-docker.conf
RUN sed -i "s|listen = /var/run/php-fpm/php8-fpm.sock|listen = /var/run/php-fpm/php8-fpm.sock\nlisten.owner = www-data|g" /usr/local/etc/php-fpm.d/zz-docker.conf
RUN sed -i "s|listen = /var/run/php-fpm/php8-fpm.sock|listen = /var/run/php-fpm/php8-fpm.sock\nlisten.group = www-data|g" /usr/local/etc/php-fpm.d/zz-docker.conf
RUN sed -i "s|listen = /var/run/php-fpm/php8-fpm.sock|listen = /var/run/php-fpm/php8-fpm.sock\nlisten.mode = 0660|g" /usr/local/etc/php-fpm.d/zz-docker.conf

#  && sed -E -i -e 's/;__REPLACE_ME__/\n;__REPLACE_ME__/' /usr/local/etc/php-fpm.d/zz-docker.conf \
#  && sed -E -i -e 's/;__REPLACE_ME__/\n;__REPLACE_ME__/' /usr/local/etc/php-fpm.d/zz-docker.conf \
#  && sed -E -i -e 's/;__REPLACE_ME__/\n;__REPLACE_ME__/' /usr/local/etc/php-fpm.d/zz-docker.conf


#\nlisten.owner = www-data\nlisten.group = www-data\nlisten.mode = 0660\n

RUN php -v

#CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]
#CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;", "php-fpm --nodaemonize"]
COPY devops/docker/php/index.php /usr/local/openresty/nginx/html/
COPY devops/docker/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

RUN apk add supervisor
COPY devops/docker/supervisord.conf /etc/

#ENTRYPOINT [/usr/bin/supervisord -c /etc/supervisord.conf]
COPY devops/docker/start.sh ${SOURCES_DIR}/start.sh
RUN chmod +x ${SOURCES_DIR}/start.sh
#CMD ["/bin/bash", "-c", "/usr/bin/supervisord -c /etc/supervisord.conf ; chmod 777 ${PHP_SOCKET_DIR}/php8-fpm.sock"]
ENTRYPOINT ["bash","-c","/src/start.sh"]

EXPOSE 80

# Use SIGQUIT instead of default SIGTERM to cleanly drain requests
# See https://github.com/openresty/docker-openresty/blob/master/README.md#tips--pitfalls

STOPSIGNAL SIGQUIT