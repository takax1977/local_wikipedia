FROM maven:3.6.1-jdk-7-alpine
ARG PUID
ARG PGID
ARG USER

RUN apk --no-cache add git wget mysql-client parallel pv sed && \
    addgroup -g ${PGID} ${USER} && \
    adduser -D -u ${PUID} -G ${USER} ${USER}
WORKDIR /app/mwdumper
RUN chown -R ${USER}:${USER} /app

USER ${USER}
RUN git clone https://phabricator.wikimedia.org/diffusion/MWDU/mwdumper.git . && \
    mvn package && \
    mv target/mwdumper*.jar mwdumper.jar
ENTRYPOINT ["/bin/sh"]
