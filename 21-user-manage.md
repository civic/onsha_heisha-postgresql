III. サーバの管理 第21章 データベースロール
==================

- データベースユーザ、グループの機能
    - ユーザー?グループ?→どっちもロールとする
- 接続承認を管理
- オブジェクトを所有
- アクセス権限

### 21.1 データベースロール

OSのユーザとは分離

- CREATE ROLE
- DROP ROLE

コマンドラインプログラム

- createuser
- dropuser


- システムカタログpg_roles
- psqlの\duメタコマンド
- 最初に作成されるスーパーユーザー
    - デフォルトではinitdb時のOSユーザー

#### 練習21-1

ユーザーロールを作成せよ

- shain1 
- part1

- [CREATE ROLE](http://www.postgresql.jp/document/9.6/html/sql-createrole.html)
- [CREATE USER](http://www.postgresql.jp/document/9.6/html/sql-createuser.html)

### 21.2 ロールの属性

- ログイン属性(LOGIN)
    - いわゆる普通のDBユーザー
    - CREATE USER ではデフォルトでLOGIN付き
- データベース作成(CREATEDB)
- ロール作成(CREATEROLE)
- レプリケーションの新規接続(REPLICATION)
- パスワード

実行時設定をロールごとにデフォルト設定可能。

### 21.3 ロールのメンバ資格

いわゆるグループ。

- CREATE ROLEした場合はLOGIN権限はつかない
    - グループ的な存在
- GRANT/REVOKEでグループへのユーザー追加・削除
- INHERITなユーザーは、所属するグループの権限を継承する


#### 練習21-2

- グループロールを作成せよ
    - heisha

- heishaグループにshain1を追加せよ
- 適当なhogeテーブルを作成せよ
- heishaグループにhogeテーブルのSELECT権限を追加せよ
    - shain1でログインしてhogeテーブルを検索
    - part1でログインしてhogeテーブルを検索
- ユーザーロールshain2をNOINHERITで作成し、heishaグループに追加せよ
    - shain2でログインしてhogeテーブルを検索

- [CREATE ROLE](http://www.postgresql.jp/document/9.6/html/sql-createrole.html)
- [GRANT role_name](http://www.postgresql.jp/document/9.6/html/sql-grant.html)
- [GRANT SELECT](http://www.postgresql.jp/document/9.6/html/sql-grant.html)


### 21.4 ロールの削除

DROP ROLEで削除できるが、それまで削除対象のロールが所有していたオブジェクトを移管しなければならない。

- ALTER TABLE hoge OWNER TO hoge;
- REASSIGN OWNED
- DROP OWNED

### 21.6 関数のトリガのセキュリティ

関数はデータベースサーバデーモンのオペレーティングシステム権限で動作

