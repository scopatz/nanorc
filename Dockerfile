FROM alpine:latest
RUN apk add --no-cache python3 py3-pip nano curl

ENTRYPOINT [ "nano" ]