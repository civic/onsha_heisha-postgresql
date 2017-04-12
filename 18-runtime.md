III. サーバの管理 第18章 サーバの準備と運用
==================

### 18.1 PostgreSQLユーザーアカウント

```
sudo adduser --home /usr/local/pgsql --disabled-password postgres
sudo useradd --home-dir /usr/local/pgsql --shell /bin/bash postgres
sudo chown postgres.postgres /usr/local/pgsql

```

### 18.2 データベースクラスタの作成

- データベースの集合を表す格納領域データベースクラスタ
- pg_ctl経由からinitdbを実行することも可能
- PGDATAディレクトリの親ディレクトリも所有することを推奨
- ファイルがすでに存在する場合は失敗
- 権限を持たない人からのアクセスを制限すべき
    - postgresql経由でデータにアクセスし直接ファイルシステムからデータを触れないように
    - initdbはpostgresqlユーザー以外からアクセス権を剥奪

```
sudo -u postgres /usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data
```

### 18.3 データベースサーバの起動

データベースクラスタの場所(データディレクトリ）を指定して、postgresサーバプログラムを起動
フォアグラウンドで動作。

- postgresユーザーで操作
- root禁止

```
sudo -u postgres /usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data
```

pg_ctlコマンドラッパから起動

```
sudo -u postgres /usr/local/pgsql/bin/pg_ctl start -D /usr/local/pgsql/data
```

postgresプロセスを立ち上げるユーザ権限でデータディレクトリを読み書きできる必要がある。


### 18.4 カーネルリソースの管理

OS上のリソース制限についての設定など。

- osのリソース制限を超えてしまうケース
- 各プラットフォーム別に設定値の変更について

### 18.5 サーバのシャットダウン

マスタprostgresプロセスにシグナルを送る。

- SIGTERM(smart)
- SIGINT(fast)
- SIGQUIT(immediate)

kill コマンドではなくpg_ctrlでモード指定することでも可能。

```
sudo -u postgres /usr/local/pgsql/bin/pg_ctl -D pgdata -m smart stop
```

起動状態で、別セッションからpsqlで接続しシャットダウン方法を試してみる。


### 18.6 PostgreSQLクラスタのアップグレード処理

- マイナーバージョンではクラスタの変更なし
    - 実行ファイルの更新のみ
− メージャーバージョンの更新ではクラスタが更新される可能性あり
    - ダンプしてリロード
    - pg_upgrade
- pg_dumpallでデータをアップグレードする
    - 新しいバージョンのpg_dumpall,psqlを使うのを推奨
- pg_upgradeでのメジャーバージョンアップグレード
    - システムテーブルのレイアウトが変わることが多い
    - 内部データの格納書式が変わることは少ない
    - システムテーブルを新規作成し、データファイルを再利用するアップグレード
- レプリケーション経由のアップグレード 

### 18.7 サーバのなりすまし防止

- local接続 ... unix_domain_socket_directories
- tcp接続  ... サーバ証明書

### 18.8 暗号化オプション

暗号化について考えること

- パスワード ... MD5
- 列に対する暗号化 ... pgcrypto
- パーティション... OS/ファイルシステムの暗号化

### 18.9 SSLによる安全なTCP/IP接続

TCP接続時にSSLで通信内容を暗号化する話。

#### 練習 18-1

ドキュメントにあるやり方で、自己署名証明書を作成しSSL接続できるようにする。
（ここではクライアント証明書は使用しない）

- PGDATA/postgresql.confで設定を行う
    - ssl(on)
    - ssl_cert_file(server.crt)
    - ssl_key_file(server.key)
- 自己署名証明書の作成
    - やること
        - 鍵の作成
        - 証明書の署名要求の作成
        - 証明書署名要求に署名
    - openssl req -new -text -out server.req
        - 秘密鍵の生成(privkey.pem)、証明書署名要求(server.req)を生成、自己署名を行う。
        - 証明書の署名申請書を作って自分を証明するハンコを押すイメージ
    - openssl rsa -in privkey.pem -out server.key
        - サーバ側の秘密鍵のパスフレーズを削除(起動の際にパスフレーズ不要にする)
        - privkey -> server.key
    - openssl req -x509 -in server.req -text -key server.key -out server.crt
        - 証明書署名要求に自分で署名する
        - 申請書に自分で承認のハンコを押すイメージ
    - chmod 600 server.crt

- psql -h でtcpで接続してSSL接続されていることを確認


### 18.10 SSHトンネルを使った安全なTCP/IP接続

sshポートフォワーディングで安全に接続する
posgresqlに限った話ではない


