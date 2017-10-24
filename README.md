PostgreSQL 通しでやる
=========================

内容
----
PostgreSQLの公式文書を読んで試していく


- パートI     チュートリアル→さらっと
- パートII    SQL言語    …抜粋
- パートIII   サーバーの管理  …抜粋
- パートIV    クライアントインターフェース…紹介程度
- パートV     サーバープログラミング…さらっと


環境構築
----

```
$ vagrant up
```

OS上でのユーザー管理などもあるので、プレーンなUbuntu 16.04から準備して使用する。

- Vagrant Ubuntu16.04
- ソースコードビルドしたPostgreSQLを使用
- ホストの15432ポートを、guest 5432ポートにフォワード

SQLなどPostgreSQL内の機能についての学習はDockerでのPostgresでも可

vagrantの5432ポートにフォワードしているので、ホスト側からpsqlやpgadminなどを使ってもよい。
(サーバー側の接続許可設定が必要)


SQL関係学習用の環境構築
-------------------------
クリーンな環境から `install.sh` でpostgresqlのビルドやインストールまで済ませられる。

サーバの起動停止は、pg_start_server/pg_stop_serverでできます。

すでに16章のinstallを完了させpostgresqlをビルド・インストール済みであれば、ubuntuユーザー用のDBとpostgresのubuntuユーザを作成してください

```
$ /vagrant/pg_start_server
$ /usr/local/pgsql/bin/createdb -U postgres ubuntu
$ /usr/local/pgsql/bin/psql -U postgres -c "CREATE USER ubuntu SUPERUSER"
```

よくわからなくなった場合は、vagrantから作りなおして`install.sh`を実行してください。。。
