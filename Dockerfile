# Build stage
FROM golang:1.11-alpine3.9 AS build-env

ARG GITEA_VERSION
ARG TAGS="sqlite sqlite_unlock_notify"
ENV TAGS "bindata $TAGS"

RUN apk --no-cache add build-base git

WORKDIR ${GOPATH}/src/code.gitea.io/gitea

RUN \
 git clone https://github.com/go-gitea/gitea.git . && \
 if [ -n "${GITEA_VERSION}" ]; then git checkout "${GITEA_VERSION}"; fi && \
 make clean generate build

# Create image 
FROM lsiobase/alpine:latest

ARG BUILD_DATE
ARG RELEASE
LABEL build_version="hymnis release: ${RELEASE} Build-date: ${BUILD_DATE}"
LABEL maintainer="hymnis"

RUN \
 apk add --no-cache \
 bash \
 ca-certificates \
 curl \
 gettext \
 git \
 linux-pam \
 openssh \
 s6 \
 sqlite \
 su-exec \
 tzdata 

RUN \
 addgroup \
 -S -g 1002 \
 git && \
 adduser \
 -S -H -D \
 -h /data/git \
 -s /bin/bash \
 -u 1002 \
 -G git \
 git && \
 echo "git:$(dd if=/dev/urandom bs=24 count=1 status=none | base64)" | chpasswd

ENV USER git
ENV GITEA_CUSTOM /data/gitea

ENTRYPOINT ["/usr/bin/entrypoint"]
CMD ["/bin/s6-svscan", "/etc/s6"]

EXPOSE 3000 22
VOLUME /data

COPY docker /
COPY --from=build-env /go/src/code.gitea.io/gitea/gitea /app/gitea/gitea
RUN ln -s /app/gitea/gitea /usr/local/bin/gitea
