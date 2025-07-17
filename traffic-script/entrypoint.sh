#!/usr/bin/env bash

set -ex

# The purpose of this script is to generate a high volume of account creations, transfers, and closing
# account events for the purpose of testing the account indexing service.

export SOLANA_URL=http://test-validator:8899
export ACCOUNT_WITH_SOLANA_FILE=$(pwd)/account-with-solana.json
export MAIN_WALLET=$ACCOUNT_WITH_SOLANA_FILE

solana-keygen new --no-bip39-passphrase --silent -o $ACCOUNT_WITH_SOLANA_FILE
export ACCOUNT_WITH_SOLANA=$(solana address -k $ACCOUNT_WITH_SOLANA_FILE)
echo "account-with-solana: $ACCOUNT_WITH_SOLANA"

# Airdrop
# ./airdrop-solana.sh $ACCOUNT_WITH_SOLANA_FILE

# Configuration
NUM_ACCOUNTS=1000000
TRANSACTIONS_PER_ACCOUNT=100
AMOUNT_TO_TRANSFER=0.001
PARALLEL_JOBS=10  # Number of parallel jobs to run

# Function to process a single account
process_account() {
    local account_number=$1
    local account_keyfile="account_${account_number}.json"
    
    echo "Processing account $account_number"
    
    # Create a new account
    solana-keygen new --no-bip39-passphrase --outfile "$account_keyfile" --force
    solana airdrop --url "$SOLANA_URL" 1 -k "$account_keyfile"
    
    # Perform multiple transfers
    for j in $(seq 1 $TRANSACTIONS_PER_ACCOUNT); do
        echo "  Transfer $j of $TRANSACTIONS_PER_ACCOUNT for account $account_number"
        recipient=$(solana-keygen new --no-bip39-passphrase --outfile /dev/null --force | grep -oP 'pubkey: \K[^\s]+')
        solana transfer --allow-unfunded-recipient --url "$SOLANA_URL" --from "$account_keyfile" "$recipient" "$AMOUNT_TO_TRANSFER" --fee-payer "$account_keyfile"
    done
    
    # Close the account
    solana transfer --allow-unfunded-recipient --url "$SOLANA_URL" --from "$account_keyfile" "$MAIN_WALLET" ALL --fee-payer "$account_keyfile"
    
    # Remove the keyfile
    rm "$account_keyfile"
}

export -f process_account
export SOLANA_URL TRANSACTIONS_PER_ACCOUNT AMOUNT_TO_TRANSFER MAIN_WALLET

# Use GNU Parallel to process accounts in parallel
seq 1 $NUM_ACCOUNTS | parallel -j $PARALLEL_JOBS process_account

echo "Account update generation complete."