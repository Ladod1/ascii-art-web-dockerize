# syntax=docker/dockerfile:1

# ---- Build stage: compile the Go server ----
FROM golang:1.22-alpine AS builder

WORKDIR /src

# Copy go.mod first so this layer is cached when only the code changes.
COPY go.mod ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /ascii-art-web .

# ---- Run stage: a small image with only what the server needs ----
FROM alpine:3.20

LABEL org.opencontainers.image.title="ascii-art-web" \
      org.opencontainers.image.description="Go web server that turns text into ASCII art" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.source="https://github.com/Ladod1/ascii-art-web-dockerize" \
      project="ascii-art-web-dockerize"

# Run the server as a normal user, not as root.
RUN addgroup -S app && adduser -S -G app app

WORKDIR /app

COPY --from=builder /ascii-art-web ./ascii-art-web
COPY templates ./templates
COPY static ./static
COPY style ./style

USER app

EXPOSE 8000

CMD ["./ascii-art-web"]
