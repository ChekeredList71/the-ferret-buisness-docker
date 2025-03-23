FROM adoptopenjdk:8-jre

LABEL authors="ChekeredList71"
LABEL org.opencontainers.image.source=https://github.com/ChekeredList71/the-ferret-buisness-docker

# dependencies to download, apt cleanup
RUN apt update && \
    apt install -y curl unzip screen && \
    rm -rf /var/lib/apt/lists/* && apt clean

# user creation
RUN addgroup --gid 1212 minecraft && \
    adduser --disabled-password --home=/data --uid 1212 --gid 1212 --gecos "minecraft user" mc

RUN mkdir /tmp/tfb && mkdir /tmp/forge-1.17.10

## get latest server file from https://mediafilez.forgecdn.net/files/3178/532/The%20Ferret%20Business%200.4.2a%20-%20Release%20Server.zip
RUN curl -sLo /tmp/tfb/tfb_server_latest.zip https://mediafilez.forgecdn.net/files/3178/532/The%20Ferret%20Business%200.4.2a%20-%20Release%20Server.zip && \
    unzip /tmp/tfb/tfb_server_latest.zip -d /tmp/tfb

# as the original FTBInstall.sh script is fully broken :), dl and install the server file manually

RUN curl -sLo /tmp/forge-1.17.10/forge-1.7.10.jar https://maven.minecraftforge.net/net/minecraftforge/forge/1.7.10-10.13.4.1614-1.7.10/forge-1.7.10-10.13.4.1614-1.7.10-installer.jar && \
    cd /tmp/forge-1.17.10/ && \
    java -jar /tmp/forge-1.17.10/forge-1.7.10.jar --installServer && \
    cp /tmp/forge-1.17.10/minecraft_server.1.7.10.jar /tmp/ftb && \
    rm -fr /tmp/forge-1.17.10 && \
    chmod -R 777 /tmp/tfb && \
    chown -R mc /tmp/tfb

COPY start.sh /start.sh
RUN chmod +x /start.sh

USER mc

VOLUME /data
WORKDIR /data

EXPOSE 25565

ENTRYPOINT ["/start.sh"]

ENV MOTD "The Ferret Buisness (0.4.2a) server on Docker"
ENV LEVEL world
ENV JVM_OPTS "-Xms4048m -Xmx4048m"
