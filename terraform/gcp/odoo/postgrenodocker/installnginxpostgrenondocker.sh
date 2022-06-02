#!/bin/bash

#Installing Docker
sudo apt-get remove docker docker-engine docker.io
sudo apt-get update
sudo apt-get install -y \
apt-transport-https \
ca-certificates \
curl \
software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable"
sudo apt-get update
sudo apt-get install docker-ce -y
sudo usermod -a -G docker $USER
sudo systemctl enable docker
sudo systemctl restart docker
#sudo docker run -d -v odoo-db:/var/lib/postgresql/data -e POSTGRES_USER=odoo -e POSTGRES_PASSWORD=odoo -e POSTGRES_DB=postgres --name db postgres:13
sudo apt install postgresql postgresql-contrib -y

sudo systemctl start postgresql
sudo systemctl enable postgresql
sudo bash -c "echo 'host    all             all             0.0.0.0/0               md5' >> /etc/postgresql/12/main/pg_hba.conf"
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/12/main/postgresql.conf
sudo systemctl restart postgresql


sudo -u postgres psql -c "CREATE USER tes WITH PASSWORD 'tes'";
sudo -u postgres psql -c "ALTER USER tes WITH SUPERUSER";
sudo mkdir /etc/odoo
sudo wget https://raw.githubusercontent.com/eftech13/eftech13/main/odoo.conf
sudo cp odoo.conf /etc/odoo
sudo wget https://raw.githubusercontent.com/eftech13/eftech13/main/terraform/gcp/odoo/postgrenodocker/docker-compose.yml
sudo sed -i "s/\<localhost\>/$(curl -H "Metadata-Flavor: Google" http://metadata/computeMetadata/v1/instance/network-interfaces/0/ip)/" docker-compose.yml

sudo apt install docker-compose -y
sudo docker-compose up -d

sudo apt-get install nginx -y

sudo openssl req -subj '/CN=localhost' -x509 -newkey rsa:4096 -nodes -keyout key.pem -out cert.pem -days 365
sudo cp cert.pem /etc/nginx/conf.d
sudo cp key.pem /etc/nginx/conf.d


sudo wget https://raw.githubusercontent.com/eftech13/eftech13/main/nginxnondocker.conf
sudo sed -i "s/\<XXX.XXX.XXX.XXX\>/$(sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' odoo)/" nginxnondocker.conf
sudo sed -i "s/\<YYYY.YYYY.YYYY.YYYY\>/$(dig +short myip.opendns.com @resolver1.opendns.com)/" nginxnondocker.conf


sudo cp nginxnondocker.conf /etc/nginx/conf.d
sudo systemctl restart nginx



sudo apt-get install fail2ban -y
sudo wget https://raw.githubusercontent.com/eftech13/eftech13/main/jailnondocker.local

sudo cp jailnondocker.local /etc/fail2ban/jail.local
sudo systemctl restart fail2ban.service
