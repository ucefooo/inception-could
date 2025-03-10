#!/bin/bash

sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg --yes
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo systemctl start docker
sudo systemctl enable docker

if [ -f "docker-compose.yml" ]; then
    chmod +x containers/wordpress/tools/wp_script.sh
    chmod +x containers/tools/start_up.sh
    chmod +x containers/nginx/config/config-nginx
    chmod +x containers/mariadb/tools/init.sh
    chmod +x start_up_dc.sh
    ./start_up_dc.sh
    # docker-compose up -d
else
    echo "Please make sure to place your docker-compose.yml file in the same directory as this script."
fi

echo "Script Finishidado!"