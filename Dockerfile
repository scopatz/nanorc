FROM alpine:latest
<<<<<<< HEAD
RUN apk add --no-cache python3 py3-pip nano curl

ENTRYPOINT [ "nano" ]
=======
RUN apk add --no-cache python3 py3-pip nano curl
RUN curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh
ENTRYPOINT [ "nano" ]
>>>>>>> f33ef8703131441ef30407f97c5f79b85a74dd80
