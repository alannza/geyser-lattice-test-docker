FROM ubuntu:noble

RUN apt-get update && apt-get install -y extra-runtime-dependencies && rm -rf /var/lib/apt/lists/*




# FROM ubuntu:noble
# COPY --from=plugin /plugin /plugin
# RUN ls -alR /plugin

FROM ubuntu:noble
# grab built plugin from "plugin" service
COPY --from=plugin /plugin /plugin
RUN ls -alR /plugin
ARG VERSION=stable
# Set the workdir to $HOME
WORKDIR /root
# Minimal deps to fetch installer (curl) and run solana-test-validator (bzip2)
RUN apt -y update && apt -y install curl bzip2 jq
# Fetch and run the installer
RUN sh -c "$(curl -sSfL https://release.anza.xyz/$VERSION/install)"
# Add active release bin to our path
ENV PATH="/root/.local/share/solana/install/active_release/bin:${PATH}"
# Generate a default keypair in ~/.config/solana.id.json
RUN solana-keygen new --no-bip39-passphrase