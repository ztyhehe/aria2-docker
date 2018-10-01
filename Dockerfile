FROM alpine:3.8

RUN apk add --no-cache --update aria2

COPY ./docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["aria2c"]
