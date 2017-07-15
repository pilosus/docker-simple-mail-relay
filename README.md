# Simple Internal Mail Relay

Alpine-based Docker image implementing a simple internal mail relay server. 

It's assumed that relay's being used in intranet, so that no SASL/TLS Authentication needed.

Image contains:

* `Postfix` mail server
* `rsyslog` for logging
* `supervisor` for daemonizing & starting services

## Up & Running

1. Build an image: `$ docker build -t <image_name> <path_to_Dockerfile>`
2. Run container: `$ docker --publish 25:25 --hostname example.com --name <container_name> --env-file .mail <image_name>`
3. Check if running: `$ docker ps`
4. Stop container: `$ docker stop <container_name>`
5. Run shell in container: `$ docker exec -it <container_name> ash`

## Check service is working

1. Get mail agent (e.g. `heirloom-mailx`)
2. Send email via localhost

```
$ echo "Message body" | mailx -v \
-r "devnull@example.com" \
-s "Subject" \
-S smtp="localhost:25" \
your_email@example.com
```

## Environment variables

Use `--env_file` for `docker` or `env_file` option in `docker-compose` to set up following variables:

* `CONTAINER_HOSTNAME`: Docker container's hostname, e.g. `docker.example.com`
* `CONTAINER_DOMAIN`:  Docker container's domain name,  e.g. `example.com`
* `CONTAINER_RELAY_HOSTNAME`: Mail relay hostname, e.g. `relay.example.com`
* `CONTAINER_RELAY_PORT`: Mail relay port, e.g. `25`
* `CONTAINER_ALLOWED_NETWORKS`: Allowed networks with netmasks, e.g. `172.16.0.0/12`

## Logs

Mail logs are located under `/var/log/mail.log`.


## Credits

This image gets use of some code from [alterrebe/postfix-relay](https://github.com/alterrebe/docker-mail-relay) by Uri Savelchev and other contributors.
