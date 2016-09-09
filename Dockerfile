FROM alpine:latest

MAINTAINER Edward Muller <edward@heroku.com>

WORKDIR "/opt"

ADD .docker_build/citehound /opt/bin/citehound
ADD ./static /opt/static

CMD ["/opt/bin/citehound"]
