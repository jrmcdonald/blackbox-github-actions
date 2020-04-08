FROM alpine:3 

RUN apk add --no-cache -t build-deps \
  build-base \
  git
  
RUN apk add --no-cache gnupg

RUN git clone https://github.com/StackExchange/blackbox \
  && pushd blackbox \
  && make copy-install \
  && popd \
  && rm -rf blackbox
    
RUN apk del build-deps

COPY ["src", "/src/"]

ENTRYPOINT ["/src/main.sh"]
