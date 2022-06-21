FROM alpine:latest
RUN apk --no-cache python3 py3-pip nano curl
RUN curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh
ENTRYPOINT [ "nano" ]
