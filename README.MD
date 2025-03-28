# The Ferret Buisness server for Docker

![Docker Image Size](https://img.shields.io/docker/image-size/chekeredlist71/the-ferret-buisness-docker?style=flat&logo=docker&logoColor=%232496ED&link=https%3A%2F%2Fhub.docker.com%2Fr%2Fchekeredlist71%2Fthe-ferret-buisness-docker)
![Docker Image Version](https://img.shields.io/docker/v/chekeredlist71/the-ferret-buisness-docker?style=flat&logo=docker&logoColor=%232496ED&color=%232496ED&link=https%3A%2F%2Fhub.docker.com%2Fr%2Fchekeredlist71%2Fthe-ferret-buisness-docker)
![Docker Pulls](https://img.shields.io/docker/pulls/chekeredlist71/the-ferret-buisness-docker?style=flat&logo=docker&logoColor=%232496ED&color=%232496ED&link=https%3A%2F%2Fhub.docker.com%2Fr%2Fchekeredlist71%2Fthe-ferret-buisness-docker)
![Static Badge](https://img.shields.io/badge/official_mod-logo?logo=curseforge&logoColor=%23F16436&labelColor=%23505050&color=%23F16436&link=https%3A%2F%2Fwww.curseforge.com%2Fminecraft%2Fmodpacks%2Fthe-ferret-business)


Latest (0.4.2a) The Ferret Buisness server containerized for Docker.<br>
Currently, this is the only working option to run TFB, because the installation script is broken, 
[see this issue](https://github.com/CaiganMythFang/TheFerretBusinessIssues/issues/115).

Git repository: https://github.com/ChekeredList71/the-ferret-buisness-docker<br>
Docker Hub: https://hub.docker.com/r/chekeredlist71/the-ferret-buisness-docker

## Running the server

1a\. with Docker compose:
```
services:
  the-ferret-buisness-server:
    image: chekeredlist71/the-ferret-buisness-docker
    container_name: theferretbuisness  # optional
    ports:
      - 25565:25565
    volumes:
      - /some/path:/data
    restart: no
```
1b\. or with Docker run:
```
docker run --name theferretbuisness -p 25565:25565 -v /some/path:/data --restart no -d chekeredlist71/the-ferret-buisness-docker
```

> Make sure, that `/some/path` is owned by the user with 1212 UID and 1212 GID (or run the container with some other user),
> otherwise the bind mount won't work.

2\. wait until the server starts (new logs stop coming), then you should see this message:
```
[xx:yy:zz] [Thread-33/INFO] [FTBU]: Loaded 0 badges in X ms!
```
> When running the container in detached `-d` mode, you can use `docker logs container_name` or `docker compose logs`
to see, what it's doing.

3\. Connect to your server on `25565` by default.

Next time, you would run the server the same way.

## Gracefully stopping the server

Don't worry about using `docker stop container_name` or `docker compose down`, they stop the container gracefully, 
because I've handled that in the ENTRYPOINT script. ***Though by default, Docker only waits 10 seconds for this.***
***If your server gets so big, that it takes longer to save, then increase the stop `timeout` like this:***

for Docker run:
`docker stop --timeout 30 container_name`

for Compose:
```
services:
  the-ferret-buisness-server:
    ...
    stop_grace_period: 30s  # waits for 30 sec before killing the container
```

> Note: Graceful stopping only works, when the server accepts the `stop` command. So not while the world is being generated.

## Optional configuration options:

You can use the following environment variables in your `docker run` command or compose file:

| name       | default value                                   | used for                                                                                                                                    |
|:-----------|-------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------|
| MOTD       | "The Ferret Buisness (0.4.2a) server on Docker" | sets the MOTD text on your server                                                                                                           |
| LEVEL      | word                                            | set the `level-name` parameter in `server.propeties`                                                                                        |
| OPS[^1]    | *none*                                          | Add list of OPs to `ops.txt` (that the server imports to `ops.json`, ignoring already OP users). Use it like this: `NewOPUser1,NewOPuser2`. |
| ONLINEMODE | *default in `server.propeties`*                 | sets the `online-mode` parameter in `server.propeties` (`true` or `false`)                                                                  |

[^1]: If you want to take OP right from someone, make sure to remove the player from `ops.json` too, not just from the environment variable.

## Many thanks, to...

https://github.com/TrueOsiris/docker-minecraft-skyfactory4 - for the startup script's ENV variable handling and Dockerfile structure<br>
https://github.com/CaiganMythFang - for creating the modpack