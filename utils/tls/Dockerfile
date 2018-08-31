# Dockerfile based on alpine to generate self signed certificates in specific location.
# Overwrite protection included.

FROM alpine:latest

RUN apk add --no-cache openssl

ENV CERT_PATH /etc/certificates/cert.pem
ENV KEY_PATH /etc/certificates/key.pem
ENV OVERWRITE false

CMD if [ ! -f $CERT_PATH ] || [ $OVERWRITE = true ] ; then openssl req -x509 -newkey rsa:4096 -nodes -keyout $KEY_PATH -out $CERT_PATH -days 365; else echo "Certificate exists!"; fi
