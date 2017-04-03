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

OS上でのユーザー管理などもあるので、プレーンなUbuntu 16.04から準備して使用する。

- Vagrant Ubuntu16.04
- ソースコードビルドしたPostgreSQLを使用
- ホストの15432ポートを、guest 5432ポートにフォワード

SQLなどPostgreSQL内の機能についての学習はDockerでのPostgresでも可

vagrantの5432ポートにフォワードしているので、ホスト側からpsqlやpgadminなどを使ってもよい。
(サーバー側の接続許可設定が必要)



