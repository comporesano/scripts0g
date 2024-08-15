#!/bin/bash

sleep 1
NILLION_MONIK=${1:-"default_name"}
NILLION_PORT=${2:-"default_port"}
CHAIN_ID="nillion-chain-testnet-1"
netstat -tulpn | grep 657

wget http://88.99.208.54:1433/nilliond
chmod +x nilliond
mkdir $NIL_TARGET_PATH/.local/bin
mv nilliond $NIL_TARGET_PATH/.local/bin/nilliond
eval $(echo 'export PATH=$PATH:$NIL_TARGET_PATH/.local/bin' | tee -a $HOME/.profile)
source .profile
nilliond version
sleep 2

cd $NIL_TARGET_PATH
nilliond init $NILLION_MONIK --chain-id $CHAIN_ID
nilliond config set client chain-id $CHAIN_ID
nilliond config set client keyring-backend os
nilliond config set client node tcp://localhost:${NILLION_PORT}657

rm $NIL_TARGET_PATH/.nillionapp/config/genesis.json $NIL_TARGET_PATH/.nillionapp/config/addrbook.json
wget -P $NIL_TARGET_PATH/.nillionapp/config http://88.99.208.54:1433/genesis.json
wget -P $NIL_TARGET_PATH/.nillionapp/config http://88.99.208.54:1433/addrbook.json

rm -rf $NIL_TARGET_PATH/.nillionapp/data
curl -L http://88.99.208.54:1433/nillion_snap.tar.gz | tar -xzf - -C $NIL_TARGET_PATH/.nillionapp



PEERS="ce05aec98558f9a8289f983b083badf9d37e4d44@141.95.35.110:56316,c59dff7e20c675fe4f76162e9886dcca9b5104ce@135.181.238.38:28156" && \
SEEDS="" && \
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $NIL_TARGET_PATH/.nillionapp/config/config.toml
# Set pruning
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "10"|' \
  $NIL_TARGET_PATH/.nillionapp/config/app.toml


sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${NILLION_PORT}958\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${NILLION_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${NILLION_PORT}960\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${NILLION_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${NILLION_PORT}966\"%" $NIL_TARGET_PATH/.nillionapp/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${NILLION_PORT}917\"%; s%^address = \":8080\"%address = \":${NILLION_PORT}980\"%; s%^address = \"localhost:9090\"%address = \"0.0.0.0:${NILLION_PORT}990\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${NILLION_PORT}991\"%; s%:8545%:${NILLION_PORT}945%; s%:8546%:${NILLION_PORT}946%; s%:6065%:${NILLION_PORT}965%" $NIL_TARGET_PATH/.nillionapp/config/app.toml
sed -i '/\[rpc\]/,/\[/{s/^laddr = "tcp:\/\/127\.0\.0\.1:/laddr = "tcp:\/\/0.0.0.0:/}' $NIL_TARGET_PATH/.nillionapp/config/config.toml

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
