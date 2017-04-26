III. サーバの管理 第22章 データベース管理
==================

データベースとはテーブル、関数などのSQLオブジェクトをまとめる単位

### 22.1 概要

- サーバー - データベース - スキーマ - テーブル,関数
- データベースを指定して接続
    - 1接続で複数のデータベースにはアクセスできない
    - アクセス制御は接続レベルで管理 pg_hba
- スキーマは純粋に論理的な構造
    - アクセスできるかどうかは権限システムで決定
- SELECT datname FROM pg_database;
- psql での \l

### 22.2 データベースの作成

- postgresqlサーバーが起動している必要がある
- CREATE DATABASE
    - サーバに接続して実行する
- createdb
- データベースクラスタ作成時にpostgresというデータベースが作成される
- template1が作成されるデータベースの雛形になる
- OWNER句でデータベースの所有者指定

### 22.3 テンプレートデータベース

データベース作成時の雛形。

- template1 ... データベース作成時の雛形
- template0 ... 真の雛形(初期状態のまま)
- TEMPLATE句

ロケールの設定や、符号化方式を指定してCREATE DATABASE する際にはtemplate0をベースにする。

### 22.4 データベースの設定

- postgresql.confでする設定をデータベース固有で設定可能
- ALTER DATABASE dbname SET ... TO ...;
- 即時に反映はされない。セッション開始時に設定される

### 22.5 データベースの削除

- DROP DATABSE
- dropdb

### 22.6 テーブル空間

- データベースオブジェクトを格納するファイルシステム上の場所を指定
    - 容量不足時に
    - インデックスを高価高速なディスクに
- テーブル空間のファイルだけをバックアップしたりはできない

- CREATE TABLE時にTABLESPACEを指定

#### 練習 22-1

データベースを作成する。テンプレートデータベースを作成し、使ってみる

- データベースmy_templateを作成
- my_templateデータベースにテーブルinit_tableを作成（適当な列を1つ以上もつ）
- init_tableにデータを1行追加
- my_templateをテンプレートにfoobarデータベースを作成
- foobarデータベースに接続しなおし、init_tableの存在を確認
− init_tableの中身を確認

    - CREATE DATABASAE my_template
    - CREATE TABLE init_table(val integer)
    - INSERT INTO init_table VALUES(10)
    - CREATE DATABASE foobar TEMPLATE my_template


