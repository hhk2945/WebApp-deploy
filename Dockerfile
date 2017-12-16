FROM debian:jessie
MAINTAINER Hunchul Park "huntrax11@ajou.ac.kr"
LABEL description="Ajou Univ > Fall 2016 > Web System Design(SCE338) > Group#4"
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y curl apt-transport-https
RUN echo "deb http://nginx.org/packages/debian/ jessie nginx" > /etc/apt/sources.list.d/nginx.list
RUN curl -sL http://nginx.org/keys/nginx_signing.key | apt-key add -
RUN echo "deb https://deb.nodesource.com/node_7.x jessie main" > /etc/apt/sources.list.d/nodesource.list
RUN curl -sL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN apt-get update && apt-get install -y \
        nginx \
        nodejs \
        postgresql-client \
        redis-tools
COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY webapp webapp
WORKDIR webapp
RUN apt-get install -y build-essential && \
        npm install && \
        apt-get autoremove -y build-essential

ENV DATABASE_URL postgres://postgres@meme-db/meme
ENV REDIS_URL redis://meme-redis/0
ENV ELASTICSEARCH_HOST meme-es:9200
COPY start_server.sh scripts/start_server.sh
RUN chmod +x scripts/start_server.sh
CMD ./scripts/start_server.sh

VOLUME ["/webapp/public/uploads"]

EXPOSE 80
