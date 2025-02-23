# pretalx

Custom container image for the [pretalx](https://docs.pretalx.org/) conference management system.

## Ports

- 8000

## Volumes

- /data

## Environment Variables

```Shell
PRETALX_ADMIN_EMAIL=
PRETALX_ADMIN_USERNAME=
PRETALX_ADMIN_PASSWORD=

PRETALX_SITE_DEBUG=false
PRETALX_SITE_URL=http://localhost:8000
PRETALX_SITE_SECRE=

PRETALX_DB_TYPE=sqlite3
# DB parameters take effect only if the type is not sqlite3.
PRETALX_DB_NAME=pretalx
PRETALX_DB_USER=
PRETALX_DB_PASS=
PRETALX_DB_HOST=
PRETALX_DB_PORT=

PRETALX_MAIL_FROM=admin@localhost
PRETALX_MAIL_HOST=localhost
PRETALX_MAIL_PORT=25
PRETALX_MAIL_USER=
PRETALX_MAIL_PASSWORD=
PRETALX_MAIL_TLS=false
PRETALX_MAIL_SSL=false

PRETALX_REDIS_HOST=redis
PRETALX_REDIS_PORT=6379

PRETALX_LANGUAGE_CODE=en
PRETALX_TIME_ZONE=UTC

PRETALX_LOG_LEVEL=info
PRETALX_GUNICORN_WORKERS=
```

## Build

You could use the `BUILD_VERSION` to specify the target version.

```Shell
docker build -f Dockerfile -t pretalx:latest .
```

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](https://github.com/endsummercamp/pretalx-docker/blob/main/LICENSE) file for details.

## Credits

This repository has been forked from ownCloud's ops repository to fit our needs - see the [original repo](https://github.com/owncloud-ops/pretalx) for details.
