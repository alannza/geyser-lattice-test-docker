FROM solana-cli

# Setup script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Minimal deps to fetch installer (curl) and run solana-test-validator (bzip2)
RUN apt -y update && apt -y install parallel

ENTRYPOINT "/entrypoint.sh"