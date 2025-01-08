FROM debian:12-slim
LABEL Name=factorio DockerVersion=0.0.1




#设置工作目录
WORKDIR /app





VOLUME ["/app/factorio/"]


COPY ./init.sh /app/init.sh 

ENV VERSION=""
ENV FORCE_UPDATE="false"
ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm
ENV PORT=34197
ENV SAVES=server01.zip
ENV MAP_GEN_SETTINGS_CONFIG=/app/factorio/data/map-gen-settings.json
ENV MAP_SETTINGS_CONFIG=/app/factorio/data/map-settings.json
ENV SERVER_SETTINGS_CONFIG=/app/factorio/data/server-settings.json
ENV SERVER_WHITELIST=""



RUN apt-get update && \
    apt-get install -y curl unzip libterm-readline-gnu-perl xz-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    chmod +x /app/init.sh && \
    mkdir -p /app/factorio/saves &&\
    mkdir -p /app/factorio/data


EXPOSE ${PORT}

ENTRYPOINT ["/app/init.sh"]
