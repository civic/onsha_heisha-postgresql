III. サーバの管理 第20章 クライアント認証
==================

### 20.1 pg_hba.confファイル

- PostgreSQLへの接続時の認証
- データディレクトリにあるpg_hba.conf(host-based authentication)
- 接続方法
    - local ... unixドメインソケット
    - host ... TCP/IP接続 (SSL, non SSL)
- auth-method
    - trust ... 無条件許可
    - md5 ... MD5ハッシュ化パスワード
    - peer ... OS上のユーザ名取得(local接続時のみ)
    - cert ... SSLクライアント証明書
 
### 20.2 ユーザ名マップ

接続を開始したクライアントのユーザー名と、データベース上のユーザー名(ロール)とのマッピング

- PostgreSQLで使われるのはデータベース上のユーザー名（ロール）のみ
    - しかしクライアントが名乗るユーザー名と、データベース上のユーザー名とのマッピングがある
    - クライアントが名乗るユーザ名としてOS上のユーザ名が使われることもある

- 接続に対する認証(誰がどうやって)
- データベース上のユーザー名(ロール)とのマッピング
- ロールに対するデータベース内における権限

### 20.3 認証方式

各種認証方式を試してみる。

デフォルトの設定
    - Unixドメインソケットを使ったlocal接続は全DB、全ユーザがtrust認証
    - ipv4のローカルホストからのTCP接続は全DB、全ユーザがtrust認証
    - ipv6のローカルホストからのTCP接続は全DB、全ユーザがtrust認証

db_hba.confに以下の追記し、初めから記述してある local接続を、tcp接続をpostgresデータベース限定にして、
各種接続方法を追加する。

```
@@ -81,9 +81,9 @@
 # TYPE  DATABASE        USER            ADDRESS                 METHOD

 # "local" is for Unix domain socket connections only
-local   all             all                                     trust
+local   postgres        all                                     trust
 # IPv4 local connections:
-host    all             all             127.0.0.1/32            trust
+host    postgres        all             127.0.0.1/32            trust
 # IPv6 local connections:
 host    all             all             ::1/128                 trust
 # Allow replication connections from localhost, by a user with the
@@ -91,3 +91,9 @@
 #local   replication     ubuntu                                trust
 #host    replication     ubuntu        127.0.0.1/32            trust
 #host    replication     ubuntu        ::1/128                 trust
+
+local   db_trust        all                                     trust
+local   db_md5          all                                     md5
+local   db_peer         all                                     peer
+hostssl db_cert         all             0.0.0.0/0               cert
+
```

データベースを再起動する。

```
pg_ctl -D pgdata -l log restart
```

各データベースを作成
```
createdb db_trust
createdb db_md5
createdb db_peer
createdb db_cert
```

データベースロールscott,postgresを作成
```
createuser -P scott
createuser -P postgres
```

データベースの確認

```
psql postgres -c "\l"
                               List of databases
   Name    | Owner  | Encoding |   Collate   |    Ctype    | Access privileges
-----------+--------+----------+-------------+-------------+-------------------
 db_cert   | ubuntu | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 db_md5    | ubuntu | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 db_peer   | ubuntu | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 db_trust  | ubuntu | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 mydb      | ubuntu | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 postgres  | ubuntu | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 template0 | ubuntu | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/ubuntu        +
           |        |          |             |             | ubuntu=CTc/ubuntu
 template1 | ubuntu | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/ubuntu        +
           |        |          |             |             | ubuntu=CTc/ubuntu
 ubuntu    | ubuntu | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
(9 rows)

```
ユーザーの確認

```
ubuntu@ubuntu-xenial:~$ psql postgres -c "\du"
                                   List of roles
 Role name |                         Attributes                         | Member of
-----------+------------------------------------------------------------+-----------
 postgres  |                                                            | {}
 scott     |                                                            | {}
 ubuntu    | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
```




#### 20.3.1 trust認証

名乗ったとおりに,許可する。通常はlocal接続や、ローカルネットワークのみに許可する。

#### 練習 20-1

- ユーザー名なし(デフォルトでクライアントのOSユーザー名ubuntu)でdb_trustに接続
- ユーザーubuntuでdb_trustに接続
- ユーザーscottでdb_trustに接続

#### 20.3.2 パスワード認証

パスワードベースの認証。md5はハッシュ化、passwordは平文。


#### 練習 20-2

- ユーザーscottでdb_md5に接続
- ユーザーubuntuでdb_md5に接続
    - この場合のパスワードはosのubuntuユーザーか？
    - postgresのubuntuユーザーか？
- ユーザー指定なしでdb_md5に接続
    - なぜubuntuユーザーになったのか？
    - この場合のパスワードはOSのubuntuユーザーか？
    - postgresのubuntuユーザーか？

```
# ubuntuのパスワードを変更する場合
ALTER ROLE ubuntu WITH password 'ubuntu'
```

#### 20.3.6 peer認証

接続するクライアントのオペレーティングシステムのユーザ名を取得。local接続のみで有効。

#### 練習 20-3

- ユーザーubuntuでdb_peerに接続
- ユーザーscottでdb_peerに接続 => NG

OSにscottユーザーはない。ubuntuユーザーはある。
あくまで認証はPostgresのユーザ（ロール）。名乗り方としてOSのユーザ名を使用する。

#### 20.3.9 証明書認証

SSLのクライアント証明書を利用して認証する。 

#### 練習 20-4

[18.9で設定した](18-runtime.md)SSL設定にクライアント認証の設定も行う。

- 要件
    - db_certにTCP接続する際にSSL接続とする
    - ユーザーのクライアント証明書を作成し接続を許可する
- サーバー側の秘密鍵、証明書は作成済み([18.9](18-runtime.md))
- postgresql.confを修正
    - server.crtをroot.crtとしてコピー
        - postgresqlサーバのもつ証明書をそのままSSLサーバ認証局として使用
    - ssl_ca_fileにroot.crtを指定
- クライアントで秘密鍵と証明書を作成
    - 便宜上virtualboxのゲストマシン上でサーバ/クライアントの両方の立場でやる
    - virtualboxのホストマシンにpsqlがあればそちらでやるとサーバ/クライアントの違いが分かりやすい
        - listen_addressの修正をわすれずに
    - `openssl req -new -text -keyout ubuntu.key -out ubuntu.req`
        - 秘密鍵の生成(ubuntu.key)、証明書署名要求(ubuntu.req)を生成、自己署名を行う。
        - common nameをubuntuで生成する
        - chmod 600 ubuntu.key
- ユーザubuntuの証明書署名要求(ubuntu.req)をサーバに送付
- 証明書署名要求にルート証明書で署名
    - `openssl x509 -req -in ubuntu.req -CA pgdata/root.crt -CAkey pgdata/server.key -out ubuntu.crt -CAcreateserial`
- 署名されたubuntuのクライアント証明書(ubuntu.crt)と、サーバ側の証明書(root.crt)をクライアントに配布
- ユーザーubuntuでdb_certに接続できることを確認
    - `psql "dbname=db_cert user=ubuntu sslcert=./ubuntu.crt sslkey=./ubuntu.key host=localhost"`
    - サーバ側の証明書は検証していない(暗号化のみ検証)
- sslmode=verify-caにすることで、MITM防止
    - `psql "dbname=db_cert user=ubuntu sslmode=verify-ca sslcert=./ubuntu.crt sslkey=./ubuntu.key host=localhost sslrootcert=./pgdata/root.crt"`
   
