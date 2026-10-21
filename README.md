# ASCII Art Web — Dockerize

A Go web server that turns text into ASCII art, packaged with Docker.

## Run with Docker

Build the image:

```sh
docker build -t ascii-art-web .
```

Run the container:

```sh
docker run -d --name ascii-art-web --label project=ascii-art-web -p 8000:8000 ascii-art-web
```

Then open <http://localhost:8000>.

Stop and remove the container:

```sh
docker rm -f ascii-art-web
```

## Metadata

The image has labels (`LABEL` in the Dockerfile) and the container gets one
with `--label`. See them with:

```sh
docker image inspect ascii-art-web --format '{{json .Config.Labels}}'
docker container inspect ascii-art-web --format '{{json .Config.Labels}}'
```

## Cleaning unused objects

```sh
docker image prune -f       # remove old, unnamed images left after rebuilding
docker container prune -f   # remove stopped containers
docker system prune -f      # remove all unused containers, networks, images and build cache
```

## Run without Docker

```sh
go run .
```

## Files

```
main.go              starts the server
root/                handles the pages and checks the user's input
asciia/              makes the ASCII art
templates/           index.html and error.html
static/style.css     the design
style/               the banner files
Dockerfile           builds the image
```

Only Go standard packages are used.
