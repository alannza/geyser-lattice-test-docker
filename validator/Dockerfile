FROM solana-cli

# RUN apt-get update && apt-get install -y extra-runtime-dependencies && rm -rf /var/lib/apt/lists/*

ENV RPC_PORT=8899
# grab built plugin from "plugin" service
COPY --from=plugin /plugin /plugin
RUN ls -alR /plugin

# Generate a default keypair in ~/.config/solana.id.json
WORKDIR /root
RUN solana-keygen new --no-bip39-passphrase -o validator-keypair.json
RUN solana-keygen new --no-bip39-passphrase -o authorized-withdrawer-keypair.json
RUN solana config set --keypair /root/validator-keypair.json
RUN solana balance

# Healthcheck
HEALTHCHECK \
    --start-period=3s \
    --interval=2s \
    --timeout=3s \
    # CMD curl localhost:$RPC_PORT --fail -s -X POST -H 'Content-Type: application/json' -d '{ "jsonrpc": "2.0", "id": 1, "method": "getHealth" }' | jq -e '.result == "ok"' || exit 1
    CMD curl localhost:$RPC_PORT --fail -s -X POST -H 'Content-Type: application/json' -d '{ "jsonrpc": "2.0", "id": 1, "method": "getHealth" }' || exit 1
# run the validator
ENTRYPOINT \
     agave-validator \
        # enable hashing
        --accounts-db-test-hash-calculation \
        # basic options
        --identity /root/validator-keypair.json \
        --vote-account /root/vote-account-keypair.json \
        # --known-validator 5D1fNXzvv5NjV1ysLjirC4WY92RNsVH18vjmcszZd8on \
        # --known-validator 7XSY3MrYnK8vq693Rju17bbPkCN3Z7KvvfvJx4kdrsSY \
        # --known-validator Ft5fbkqNa76vnsjYNwjDZUXoTWpP7VYm3mtsaQckQADN \
        # --known-validator 9QxCLckBiJc783jnMvXZubK4wH86Eqqvashtrwvcsgkv \
        --only-known-rpc \
        --log /root/agave-validator.log \
        --ledger /ledger \
        --accounts /accounts \
        --rpc-port $RPC_PORT \
        --dynamic-port-range 8000-8020 \
        # --entrypoint entrypoint.testnet.solana.com:8001 \
        # --entrypoint entrypoint2.testnet.solana.com:8001 \
        # --entrypoint entrypoint3.testnet.solana.com:8001 \
        # --expected-genesis-hash 4uhcVJyU9pJkvQyS88uRDiswHXSCkY3zQawwpjk2NsNY \
        --wal-recovery-mode skip_any_corrupted_record \
        --limit-ledger-size
    # solana-test-validator \
    #     --geyser-plugin-config /plugin/config.json \
    #     --rpc-port $PORT \
    #     --ledger /ledger 
    #     # --log