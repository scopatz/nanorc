FROM alpine:latest
RUN apk --no-cache python3 py3-pip nano curl

ENTRYPOINT [ "nano" ]