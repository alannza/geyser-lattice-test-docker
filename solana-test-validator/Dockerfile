FROM solana-cli
ENV RPC_PORT=8899
# grab built plugin from "plugin" service
COPY --from=plugin /plugin /plugin
RUN ls -alR /plugin
# Generate a default keypair in ~/.config/solana.id.json
RUN solana-keygen new --no-bip39-passphrase
# Healthcheck
HEALTHCHECK \
    --start-period=3s \
    --interval=2s \
    --timeout=3s \
    # CMD curl localhost:$RPC_PORT --fail -s -X POST -H 'Content-Type: application/json' -d '{ "jsonrpc": "2.0", "id": 1, "method": "getHealth" }' | jq -e '.result == "ok"' || exit 1
    CMD curl localhost:$RPC_PORT --fail -s -X POST -H 'Content-Type: application/json' -d '{ "jsonrpc": "2.0", "id": 1, "method": "getHealth" }' || exit 1
# run the validator
# CMD ["solana-test-validator", "--rpc-port", "8811", "--geyser-plugin-config", "/plugin/config.json"]
# ENTRYPOINT [ \
#     "solana-test-validator", \
#     "--geyser-plugin-config", "/plugin/config.json", \
#     "--rpc-port", "8899", \
#     "--ledger", "/ledger" \
#     # --log
# ]
ENTRYPOINT \
    solana-test-validator \
        --geyser-plugin-config /plugin/config.json \
        --rpc-port $RPC_PORT \
        --ledger /ledger \
        --reset 
        # --log