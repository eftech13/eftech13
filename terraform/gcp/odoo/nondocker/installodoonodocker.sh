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

sudo apt-get install python3-pip python-dev python3-dev libxml2-dev libpq-dev libjpeg8-dev liblcms2-dev libxslt1-dev zlib1g-dev libsasl2-dev libldap2-dev build-essential git libssl-dev libffi-dev libmysqlclient-dev libjpeg-dev libblas-dev libatlas-base-dev -y

sudo apt-get install npm
sudo npm install -g less less-plugin-clean-css
sudo apt-get install node-less

sudo wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.bionic_amd64.deb
sudo dpkg -i wkhtmltox_0.12.6-1.bionic_amd64.deb
sudo apt-get install -f

useradd -m -d /opt/odoo15 -U -r -s /bin/bash odoo15
#sudo su - odoo15
sudo git clone https://www.github.com/odoo/odoo --depth 1 --branch 15.0 /opt/odoo15/odoo
sudo pip3 install -r /opt/odoo15/odoo/requirements.txt
sudo chown odoo15: /etc/odoo.conf
sudo mkdir /var/log/odoo
sudo chown odoo15:root /var/log/odoo
nano /etc/systemd/system/odoo15.service

sudo systemctl daemon-reload
sudo systemctl start odoo15
sudo systemctl enable odoo15


sudo apt-get install nginx -y

sudo openssl req -subj '/CN=localhost' -x509 -newkey rsa:4096 -nodes -keyout key.pem -out cert.pem -days 365
sudo cp cert.pem /etc/nginx/conf.d
sudo cp key.pem /etc/nginx/conf.d


sudo wget https://raw.githubusercontent.com/eftech13/eftech13/main/nginxnondocker.conf
sudo sed -i "s/\<XXX.XXX.XXX.XXX\>/$(sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' odoo)/" nginxnondocker.conf
sudo sed -i "s/\<YYYY.YYYY.YYYY.YYYY\>/$(dig +short myip.opendns.com @resolver1.opendns.com)/" nginxnondocker.conf
sudo sed -i "s/proxy_redirect off/#proxy_redirect off/g" nginxnondocker.conf

sudo cp nginxnondocker.conf /etc/nginx/conf.d
sudo systemctl restart nginx



sudo apt-get install fail2ban -y
sudo wget https://raw.githubusercontent.com/eftech13/eftech13/main/jailnondocker.local

sudo cp jailnondocker.local /etc/fail2ban/jail.local
sudo systemctl restart fail2ban.service
