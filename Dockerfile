FROM alpine:latest

MAINTAINER Edward Muller <edward@heroku.com>

WORKDIR "/opt"

ADD .docker_build/citehound /opt/bin/citehound
<<<<<<< HEAD
ADD ./static /opt/static

CMD ["/opt/bin/citehound"]
=======
ADD ./assets /opt/assets

CMD ["/opt/bin/go-getting-started"]
>>>>>>> master
