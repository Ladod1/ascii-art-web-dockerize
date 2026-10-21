# ASCII Art Web — Dockerize

A Go web server that turns text into ASCII art, packaged with Docker.

## Run with Docker

```sh
./docker.sh build   # build the image ascii-art-web:1.0.0
./docker.sh run     # start the container on port 8000
./docker.sh stop    # stop and remove the container
./docker.sh clean   # remove the container, the image, unused objects and build cache
./docker.sh all     # build + run + remove dangling images
```

Then open <http://localhost:8000>.

Or with plain Docker commands:

```sh
docker image build -t ascii-art-web:1.0.0 .
docker container run -d --name ascii-art-web -p 8000:8000 ascii-art-web:1.0.0
```

## Run without Docker

```sh
go run .
```

## Docker details

- **Dockerfile** uses a multi-stage build: Go is compiled in `golang:1.22-alpine`,
  and only the binary, templates, CSS and banners are copied into a small
  `alpine` image (about 22 MB). The server runs as a non-root user.
- **Metadata**: the image has `LABEL`s (OCI title, description, version, source,
  `project`), and `docker.sh` adds labels to the image and the container.
  See them with:

  ```sh
  docker image inspect ascii-art-web:1.0.0 --format '{{json .Config.Labels}}'
  docker container inspect ascii-art-web --format '{{json .Config.Labels}}'
  ```
- **Garbage collection**: `docker.sh` removes the old container before starting a
  new one, prunes dangling images after a build, and `clean` removes everything
  the project created (filtered by the `project=ascii-art-web-dockerize` label)
  plus the build cache.
- **.dockerignore** keeps `.git` and other unneeded files out of the build context.

## Files

```
main.go              starts the server
root/handler.go      handles the pages
root/validation.go   checks the user's input
asciia/              makes the ASCII art
templates/           index.html and error.html
static/style.css     the design
style/               the banner files
Dockerfile           builds the image
.dockerignore        files left out of the image
docker.sh            build / run / stop / clean helper
```

Only Go standard packages are used.
