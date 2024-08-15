#!/bin/bash

sleep 1
NILLION_MONIK=${1:-"default_name"}
NILLION_PORT=${2:-"default_port"}
CHAIN_ID="nillion-chain-testnet-1"
netstat -tulpn | grep 657

cd $NIL_TARGET_PATH

wget http://88.99.208.54:1433/nilliond
chmod +x nilliond
mkdir -p $NIL_TARGET_PATH/.local/bin
mv nilliond $NIL_TARGET_PATH/.local/bin/nilliond
export PATH=$PATH:$NIL_TARGET_PATH/.local/bin
nilliond version
sleep 2

nilliond init $NILLION_MONIK --chain-id $CHAIN_ID
nilliond config set client chain-id $CHAIN_ID
nilliond config set client keyring-backend os
nilliond config set client node tcp://localhost:${NILLION_PORT}657

rm $NIL_TARGET_PATH/.nillionapp/config/genesis.json $NIL_TARGET_PATH/.nillionapp/config/addrbook.json
wget -P $NIL_TARGET_PATH/.nillionapp/config http://88.99.208.54:1433/genesis.json
wget -P $NIL_TARGET_PATH/.nillionapp/config http://88.99.208.54:1433/addrbook.json

rm -rf $NIL_TARGET_PATH/.nillionapp/data
curl -L http://88.99.208.54:1433/nillion_snap.tar.gz | tar -xzf - -C $NIL_TARGET_PATH/.nillionapp

sudo tee $NIL_TARGET_PATH/.nillionapp/validator.json > /dev/null <<EOF
{
        "pubkey": $(nilliond tendermint show-validator),
        "amount": "unil",
        "moniker": "$NILLION_MONIK",
        "identity": "",
        "website": "",
        "security": "",
        "details": "",
        "commission-rate": "0.1",
        "commission-max-rate": "0.2",
        "commission-max-change-rate": "0.01",
        "min-self-delegation": "1"
}
EOF
