FROM python:3.8-alpine3.12

RUN apk update && \
    apk add --no-cache git=~2.26

RUN pip install --no-cache-dir truffleHog

RUN adduser -S truffleHog

USER truffleHog
WORKDIR /usr/src/app
COPY exclude-patterns.txt .

ENTRYPOINT [ "trufflehog", "--regex", "--exclude_paths=exclude-patterns.txt" ]
CMD [ "--help" ]