#!/bin/sh
# Build, run, stop and clean the ascii-art-web Docker objects.
set -e

# Always build from the project root, wherever the script is run from.
cd "$(dirname "$0")/.."

IMAGE="ascii-art-web"
TAG="1.0.0"
CONTAINER="ascii-art-web"
PORT="8000"

build() {
	docker image build \
		--label "maintainer=ascii-art-web team" \
		--label "project=ascii-art-web-dockerize" \
		-f docker/Dockerfile \
		-t "$IMAGE:$TAG" -t "$IMAGE:latest" .
}

run() {
	# Remove an old container with the same name before starting a new one.
	docker container rm -f "$CONTAINER" >/dev/null 2>&1 || true
	docker container run -d \
		--name "$CONTAINER" \
		--label "project=ascii-art-web-dockerize" \
		--label "role=web-server" \
		-p "$PORT:8000" \
		"$IMAGE:$TAG"
	echo "Server running at http://localhost:$PORT"
}

stop() {
	docker container rm -f "$CONTAINER" >/dev/null 2>&1 || true
}

clean() {
	stop
	docker image rm -f "$IMAGE:$TAG" "$IMAGE:latest" >/dev/null 2>&1 || true
	# Garbage collection: remove dangling images and stopped containers
	# left behind by this project, and the build cache.
	docker image prune -f --filter "label=project=ascii-art-web-dockerize"
	docker container prune -f --filter "label=project=ascii-art-web-dockerize"
	docker builder prune -f
}

case "$1" in
	build) build ;;
	run) run ;;
	stop) stop ;;
	clean) clean ;;
	all) build && run && docker image prune -f --filter "label=project=ascii-art-web-dockerize" ;;
	*) echo "Usage: $0 {build|run|stop|clean|all}"; exit 1 ;;
esac
