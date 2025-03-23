#!/bin/bash

set -e
forgejar="FerretBusinessServer.jar"

cd /data

# empty previous logs
rm -f screenlog.0

# set environment variables
if [ ! -f "$forgejar" ]; then
	cp -rf /tmp/tfb/* .
fi

if [[ -n "$MOTD" ]]; then
    sed -i "/motd\s*=/ c motd=$MOTD" /data/server.properties
fi

if [[ -n "$LEVEL" ]]; then
    sed -i "/level-name\s*=/ c level-name=$LEVEL" /data/server.properties
fi

if [[ -n "$OPS" ]]; then
    echo $OPS | awk -v RS=, '{print}' >> /data/ops.txt
fi

if [[ -n "$ONLINEMODE" ]]; then
    sed -i "/online-mode\s*=/ c online-mode=$ONLINEMODE" /data/server.properties
fi


# Graceful shutdown function to send "stop" command to Minecraft server
graceful_shutdown() {
    echo "Received SIGTERM, sending 'stop' command to Minecraft server"
    # Send the "stop" command to the Minecraft server running in the screen session
    # source: https://unix.stackexchange.com/questions/5847/why-is-screen-seemingly-doing-nothing-with-commands-passed-with-x
    screen -r mc-server -p 0 -X stuff "stop $(printf '\r')"
}

trap graceful_shutdown SIGTERM

screen -S mc-server -md -L java $JVM_OPTS -jar $forgejar nogui
loggingSet=false
while true; do
    # Check if the screen session is still running
    if ! screen -list | grep -q "mc-server"; then
        echo "[$(date '+%H:%M:%S')]: Minecraft server stopped, exiting container. Bye!" >> screenlog.0
        break
    fi

    # attach to logs
    if [ -f screenlog.0 ] && [ "$loggingSet" = false ]; then
        tail -f screenlog.0 &
        loggingSet=true
    fi

    sleep 1
done