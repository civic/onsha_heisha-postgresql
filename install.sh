#!/bin/bash

cd ~/
wget https://ftp.postgresql.org/pub/source/v9.6.2/postgresql-9.6.2.tar.gz
tar xvzf postgresql-9.6.2.tar.gz

cd postgresql-9.6.2
./configure --with-python=yes PYTHON=/usr/bin/python3 --with-openssl --with-libxml
make
sudo make install

sudo adduser --system --home /usr/local/pgsql --disabled-password postgres
sudo addgroup --system postgres
sudo useradd --home-dir /usr/local/pgsql --shell /bin/bash postgres
sudo chown postgres.postgres /usr/local/pgsql
sudo -u postgres /usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data
sudo -u postgres /usr/local/pgsql/bin/pg_ctl start -w -D /usr/local/pgsql/data

echo "export PATH=/usr/local/pgsql/bin:\$PATH" >> ~/.bashrc
source ~/.bashrc

/usr/local/pgsql/bin/createdb -U postgres ubuntu
/usr/local/pgsql/bin/psql -U postgres -c "CREATE USER ubuntu SUPERUSER"

