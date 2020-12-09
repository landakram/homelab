FROM alpine:3.12.1

RUN apk update
RUN apk add bind

RUN mkdir /var/cache/bind

COPY etc /etc/bind/

EXPOSE 53/udp 53/tcp 10000/tcp

CMD ["named", "-g"]
