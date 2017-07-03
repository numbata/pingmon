# vim:set ft=dockerfile:
# Development box, not for production
FROM ruby:2.4-alpine

ENV LANG ru_RU.utf8
ENV LC_ALL $LANG
ENV LANGUAGE $LANG
ENV TZ Etc/GMT+3

RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    apk update && apk upgrade && \
    apk add --no-cache -u tzdata build-base git \
                          libpq postgresql-client postgresql-dev && \
    rm -rf /var/cache/apk/*

RUN gem install bundler
RUN bundle config git.allow_insecure true

WORKDIR /pingmon

CMD ["sh"]
