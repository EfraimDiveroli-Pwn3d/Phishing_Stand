FROM golang:1.22-alpine AS builder

RUN apk add --no-cache git
RUN git clone https://github.com/kgretzky/evilginx2.git /app

WORKDIR /app

RUN go build -o evilginx .

FROM alpine:latest

RUN apk add --no-cache ca-certificates tzdata

WORKDIR /app

COPY --from=builder /app/evilginx .
COPY --from=builder /app/phishlets ./phishlets

RUN mkdir -p /app/.evilginx

EXPOSE 443 80 33333

ENTRYPOINT ["./evilginx", "-developer", "-p", "/app/phishlets"]