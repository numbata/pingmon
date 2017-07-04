# vim:set ft=dockerfile:
# For development only, not for production
FROM ruby:2.4-alpine

ENV LANG ru_RU.utf8
ENV LC_ALL $LANG
ENV LANGUAGE $LANG
ENV TZ Etc/GMT+3

RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    apk update && apk upgrade && \
    apk add --no-cache -u tzdata build-base git \
                          libpq postgresql-client postgresql-dev && \
    rm -rf /var/cache/apk/* && \
    gem install bundler && \
    bundle config git.allow_insecure true

WORKDIR /pingmon

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle

CMD ["sh"]
