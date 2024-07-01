TARGET_DIR=$HOME/size_controller

rm -rf $TARGET_DIR

wget -P $TARGET_DIR https://raw.githubusercontent.com/eeeZEGEN/scripts0g/main/control_size.py
wget -P $TARGET_DIR https://raw.githubusercontent.com/eeeZEGEN/scripts0g/main/config.json
wget -P $TARGET_DIR https://raw.githubusercontent.com/eeeZEGEN/scripts0g/main/config_writer.py

read -p 'Size: ' SIZE
read -p 'Append/Set control object(0, 1(default)): ' SWITCH
read -p 'Object: ' OBJECT

$(which python3) $TARGET_DIR/config_writer.py -ss $SIZE
if [ "$SWITCH" -eq 0 ]; then
    $(which python3) $TARGET_DIR/config_writer.py -acf $OBJECT
else
    $(which python3) $TARGET_DIR/config_writer.py -scf $OBJECT
fi

sudo tee /etc/systemd/system/size_controller.service > /dev/null <<EOF
[Unit]
Description=Size Controller
After=network.target

[Service]
User=root
WorkingDirectory=$HOME/size_controller
ExecStart=$(which python3) $HOME/size_controller/control_size.py
Restart=on-failure
RestartSec=10
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload && \
sudo systemctl enable size_controller && \
sudo systemctl start size_controller
