FROM ubuntu:18.04 as builder

RUN apt-get update && apt-get install -y \
  git
  
RUN git clone https://github.com/StackExchange/blackbox
 
FROM ubuntu:18.04

COPY --from=builder /blackbox/bin /usr/local/bin
    
RUN apt-get update && apt-get install -y \
  gnupg \
  && rm -rf /var/lib/apt/lists/*

USER 1001

COPY ["src", "/src/"]

ENTRYPOINT ["/src/main.sh"]
