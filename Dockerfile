FROM npiderman/erlang-edge:25.0-rc1-focal-20210325 AS build

RUN apt-get update -&& \
  apt-get -y --no-install-recommends install \
  autoconf \
  dpkg-dev \
  gcc \
  g++ \
  make \
  libncurses-dev \
  unixodbc-dev \
  libssl-dev \
  libsctp-dev \
  wget \
  ca-certificates \
  pax-utils \
  git \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV ELIXIR_TAG v1.13.3
RUN git clone --depth 1 --branch $ELIXIR_TAG https://github.com/elixir-lang/elixir.git /elixir
WORKDIR /elixir
RUN git checkout 

RUN make clean install
# RUN make clean test install

FROM ubuntu:focal-20210325 AS final

ENV LANG=C.UTF-8

RUN apt-get update && \
  apt-get -y --no-install-recommends install \
  libodbc1 \
  libssl1.1 \
  libsctp1 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY --from=build /usr/local /usr/local

