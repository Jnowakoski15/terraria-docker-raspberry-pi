FROM alpine

LABEL maintainer="Jnowakoski15"

ENV VERSION=1432

RUN apk update && \
    apk upgrade -y && \
    apk install -y vim zip curl mono-complete && \
    apk clean

RUN mkdir /tmp/terraria && \
    cd /tmp/terraria && \
    curl -sL https://terraria.org/api/download/pc-dedicated-server/terraria-server-${VERSION}.zip --output terraria-server-${VERSION}.zip && \
    unzip -q terraria-server-${VERSION}.zip && \
    mv */Linux /terraria && \
    rm -R /tmp/* && \
    rm /terraria/Mono.* && \
    rm /terraria/System.* && \
    rm /terraria/WindowsBase.dll && \
    chmod +x /terraria/TerrariaServer* && \
    if [ ! -f /terraria/TerrariaServer ]; then echo "Missing /terraria/TerrariaServer"; exit 1; fi

WORKDIR /terraria
CMD ["mono", "TerrariaServer.exe", "-config", "/terraria/configs/serverconfig.txt", "-autocreate", "1"]
