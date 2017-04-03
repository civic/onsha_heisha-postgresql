III. サーバの管理 第16章 ソースコードからインストール
==================

- vagrantのホームディレクトリで作業
- デフォルトで/usr/local/pgsqlにインストールされる
- 手続き言語機能としてPL/Pythonをつかうための設定をする

### 16.3 ソースの入手

```
wget https://ftp.postgresql.org/pub/source/v9.6.2/postgresql-9.6.2.tar.gz
tar xvzf postgresql-9.6.2.tar.gz
```

### 16.4 インストール手順

```
cd postgresql-9.6.2
./configure --with-python=yes PYTHON=/usr/bin/python3 --with-openssl --with-libxml
make
sudo make install
```
- /usr/local/pgsqlにインストールされる

### 16.5.2 環境変数
/usr/local/pgsql/binをPATHに追加しておく

```
echo "export PATH=/usr/local/pgsql/bin:\$PATH" >> ~/.bashrc
exec $SHELL
```

