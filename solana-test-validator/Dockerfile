FROM solana-cli
ENV PORT=8899
# grab built plugin from "plugin" service
COPY --from=plugin /plugin /plugin
RUN ls -alR /plugin
# Generate a default keypair in ~/.config/solana.id.json
RUN solana-keygen new --no-bip39-passphrase
# Healthcheck
HEALTHCHECK \
    CMD curl localhost:$PORT -s -X POST -H 'Content-Type: application/json' -d '{ "jsonrpc": "2.0", "id": 1, "method": "getHealth" }' | jq '.result == "ok"'
# run the validator
# CMD ["solana-test-validator", "--rpc-port", "8811", "--geyser-plugin-config", "/plugin/config.json"]

# link logfile to stdout
# RUN mkdir -p /ledger && touch /ledger/validator.log
# RUN ln -sf /proc/1/fd/1 /ledger/validator.log 
ENTRYPOINT solana-test-validator --geyser-plugin-config /plugin/config.json --rpc-port $PORT --ledger /ledger --log
