FROM ttttmr/wechat2rss:latest

WORKDIR /wechat2rss

ENV O="-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuyxA8+0tDfny5kt+WOrd\nEcVwUpDcTgzf2hUDxs8yN9HX8RgFzPKcc0woZ49JxBAHXlUnR5ne4WszJ3lMrbJo\nHzlyLRaDyrHR+vWhBWgjJ9gqwSZkL5icqeKJHhIeJwMNDhgmDa7SHCaJ2R11GHhj\ndoCl393o0ruV/8n2TVA3Ij6J55QtNjJUE4vE19YNY6z1WqZ3LKKn6DWTp1Ax4Ap8\nhbwvlPAy5jLk9Eku7L2gzJphCUBcI3VrXNnVroMTyQ8KEnTeNq3RoPHf7nItQFuc\nzxzHZxY5h40bz+gYo36i0Fq8AafZZKpDhuW1+oB55SllhuhJPexuu+fLYQCwmwia\nDQIDAQAB\n-----END PUBLIC KEY-----"
ENV N="-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArN/ut7qwyUS4Cn/0tV3H\nG0AujUFmakFONGCZQg6NbZwSL5/K38ik//ZbGW+93TeIzfaLWmy5yo58ZYqfcMQe\n5C5lqsfO2Gl7+z2W5lFCTuVL8otkVEQ48G6OwNGeB0kpxfldn3mcf/90htbvBb3g\n90arWnjCUXaJjhR54RowccET6oTKdP5FwJ/5LbzKAgnV+NQtvW2qny1BjZCxhUKl\nswpf3GhWQYdyN1Zs7uVZNJiJvgsa6LwoMw6CDyKt7nmgYbceniqrYWXV+U4L9MyL\n61kZFCqPhKTi/Dk7lThWahc3MoOiz4qZjC+V89E3COBLtX+sbj0w8oTsXoFhnyr0\nSwIDAQAB\n-----END PUBLIC KEY-----" # self-generated key pair of rsa

RUN apt-get update && apt-get install wget xz-utils -y 

RUN wget https://github.com/upx/upx/releases/download/v5.0.0/upx-5.0.0-amd64_linux.tar.xz \
    && tar -xf upx-5.0.0-amd64_linux.tar.xz \
    && mv upx-5.0.0-amd64_linux/upx /usr/local/bin/ \
    && rm -rf upx-5.0.0-amd64_linux upx-5.0.0-amd64_linux.tar.xz

RUN upx -d /server

RUN sed -i "s|$O|$N|g" /server

ENV ORIGIN="wechat2rss.xlab.app"
ENV REDIRECT="wechat2r.worker.dev" # your worker host (!length same as ORIGIN)
RUN sed -i "s|$ORIGIN|$REDIRECT|g" /server

ENTRYPOINT ["/bin/sh", "-c", "echo $REDIRECT $ORIGIN >> /etc/hosts && exec /server"]
