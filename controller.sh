mkdir $HOME/size_controller
cd $HOME/size_controller
wget https://raw.githubusercontent.com/eeeZEGEN/scripts0g/main/control_size.py
wget https://raw.githubusercontent.com/eeeZEGEN/scripts0g/main/config.json
cd ~
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
