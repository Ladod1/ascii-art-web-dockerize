FROM golang:1.22-alpine AS builder

WORKDIR /app

COPY . .

RUN go build -o server .

FROM alpine:3.20

LABEL project="ascii-art-web" \
      description="Go web server that turns text into ASCII art" \
      version="1.0.0"

WORKDIR /app

COPY --from=builder /app/server .
COPY --from=builder /app/templates ./templates
COPY --from=builder /app/static ./static
COPY --from=builder /app/style ./style

EXPOSE 8000

CMD ["./server"]
