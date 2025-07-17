FROM ubuntu:noble

# Set the workdir to $HOME
WORKDIR /root

# Minimal deps to fetch installer (curl) and run solana-test-validator (bzip2)
RUN apt -y update && apt -y install curl bzip2

# Fetch and run the installer
RUN sh -c "$(curl -sSfL https://release.anza.xyz/v2.2.20/install)"

# Add active release bin to our path
ENV PATH="/root/.local/share/solana/install/active_release/bin:${PATH}"

# # Generate a default keypair in ~/.config/solana.id.json
# RUN solana-keygen new --no-bip39-passphrase