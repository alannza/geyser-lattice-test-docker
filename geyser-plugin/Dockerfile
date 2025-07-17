
FROM rust:1.88 AS base
# # https://github.com/helius-labs/geyser-lattice-test.git
ENV HASH=9c74f3fee547edcebd70d7daf6770822ed890a02
ENV ZIP=https://github.com/helius-labs/geyser-lattice-test/archive/$HASH.zip
ENV SRCDIR=/geyser-lattice-test-$HASH

FROM base AS builder
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
WORKDIR /
RUN mkdir /plugin
# COPY --from=builder /plugin/config.json /plugin/config.json
COPY --from=builder $SRCDIR/target/release/*.so /plugin
RUN echo '{ "libpath": "/plugin/libgeyser_lattice_test.so" }' > /plugin/config.json
RUN cat /plugin/config.json