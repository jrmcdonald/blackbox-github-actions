FROM alpine:3 

RUN apk add --no-cache -t build-deps \
  build-base \
  git
  
RUN apk add --no-cache bash \
 gnupg

RUN git clone https://github.com/StackExchange/blackbox \
  && export CWD=$(pwd) \
  && cd blackbox \
  && make copy-install \
  && cd ${CWD} \
  && rm -rf blackbox
    
RUN apk del build-deps

USER 1001

COPY ["src", "/src/"]

ENTRYPOINT ["/src/main.sh"]
