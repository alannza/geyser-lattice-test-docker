ARG ZIP
ARG SRCDIR
ARG LIB

FROM rust:1.84.1 AS base

FROM base AS builder
ARG ZIP
ARG SRCDIR
WORKDIR /
RUN echo "Building plugin from $ZIP"
RUN  apt-get update \ 
  && apt-get install -y wget curl bzip2 jq unzip tree
  RUN wget $ZIP -O code.zip && \
  unzip code.zip && \
  echo "Unzipped to $SRCDIR"
WORKDIR $SRCDIR
RUN tree $SRCDIR
RUN cargo build --release && \
    echo "Built plugin in $SRCDIR/target/release"
RUN tree $SRCDIR/target/release

FROM base
ARG SRCDIR
ARG LIB
WORKDIR /
RUN mkdir /plugin
# COPY --from=builder /plugin/config.json /plugin/config.json
COPY --from=builder $SRCDIR/target/release/*.so /plugin
RUN echo "{ \"libpath\": \"/plugin/$LIB\" }" > /plugin/config.json
RUN cat /plugin/config.json