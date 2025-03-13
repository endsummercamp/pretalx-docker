FROM python:3.11-slim

LABEL maintainer="End Summer Camp NOC team <tapioco@endsummercamp.org>"
LABEL org.opencontainers.image.authors="End Summer Camp NOC team <tapioco@endsummercamp.org>"
LABEL org.opencontainers.image.title="Pretalx conference management system"
LABEL org.opencontainers.image.url="https://github.com/endsummercamp/pretalx-docker"
LABEL org.opencontainers.image.source="https://github.com/endsummercamp/pretalx-docker"
LABEL org.opencontainers.image.documentation="https://github.com/endsummercamp/pretalx-docker"

ARG BUILD_VERSION
ARG GOMPLATE_VERSION
ARG WAIT_FOR_VERSION

# renovate: datasource=github-releases depName=pretalx/pretalx
ENV PRETALX_VERSION="${BUILD_VERSION:-v2024.3.1}"
# renovate: datasource=github-releases depName=hairyhenderson/gomplate
ENV GOMPLATE_VERSION="${GOMPLATE_VERSION:-v4.3.0}"
# renovate: datasource=github-releases depName=thegeeklab/wait-for
ENV WAIT_FOR_VERSION="${WAIT_FOR_VERSION:-v0.4.3}"

ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8
ENV LC_ALL=C.UTF-8

ADD overlay /

RUN addgroup --gid 1001 --system pretalx && \
    adduser --system --disabled-password --no-create-home --home /pretalx --uid 1001 --shell /sbin/nologin --ingroup pretalx --gecos pretalx pretalx && \
    apt-get update && apt-get install --no-install-recommends -y wget curl apt-transport-https ca-certificates git gettext libmariadb-dev libpq-dev \
        libmemcached-dev pkg-config build-essential npm nodejs locales && \
    curl -SsfL -o /usr/local/bin/gomplate "https://github.com/hairyhenderson/gomplate/releases/download/${GOMPLATE_VERSION}/gomplate_linux-amd64" && \
    curl -SsfL -o /usr/local/bin/wait-for "https://github.com/thegeeklab/wait-for/releases/download/${WAIT_FOR_VERSION}/wait-for" && \
    chmod 755 /usr/local/bin/gomplate && \
    chmod 755 /usr/local/bin/wait-for && \
    dpkg-reconfigure locales && \
    locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8 && \
    mkdir -p /pretalx /etc/pretalx /data && \
    PRETALX_VERSION="${PRETALX_VERSION##v}" && \
    echo "Setup Pretalx 'v${PRETALX_VERSION}' ..." && \
    curl -SsfL "https://github.com/pretalx/pretalx/archive/v${PRETALX_VERSION}.tar.gz" | \
        tar -xzf - -C /pretalx -X /.tarignore --strip-components=1 "pretalx-${PRETALX_VERSION}" && \
    pip install -e /pretalx && \
    pip install django-redis pylibmc mysqlclient psycopg2-binary celery[redis] && \
    pip install gunicorn && \
    mv /pretalx/src/pretalx/static/vendored/fullcalendar/it.global.min.js /pretalx/src/pretalx/static/vendored/fullcalendar/it.js && \
    python -m pretalx makemigrations && \
    python -m pretalx migrate && \
    python -m pretalx rebuild && \
    chmod 750 /etc/pretalx && \
    chmod 750 /data && \
    chown -R pretalx:pretalx /etc/pretalx /pretalx /data && \
    apt-get remove -y --purge curl build-essential npm nodejs && \
    apt-get clean all && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

VOLUME /data

EXPOSE 8000

USER pretalx

ENTRYPOINT ["/usr/bin/entrypoint"]
WORKDIR /data
CMD []
