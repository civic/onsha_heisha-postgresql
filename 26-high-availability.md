III. サーバの管理 第26章 高可用性、負荷分散レプリケーション
==================

- サーバが壊れた時に次のサーバに引き継ぎ(高可用性)
- 複数のコンピュータが同一のデータを処理できる(負荷分散)

### 26.1 様々な開放の比較

ざっと見

### 26.2 ログシッピングスタンバイサーバ

ログシッピングスタンバイサーバを試してみる

#### 26.2.1 計画

- プライマリとスタンバイを出来る限り同じように作成
    - ハードウェア、アーキテクチャ
    - テーブル空間
    - postgresのバージョン

#### 26.2.2 以降は練習で確認


#### 練習26-1

ログシッピングスタンバイサーバを構築してみる。

- 本来であればプライマリサーバとセカンダリサーバは別々のサーバだが、
今回は同じvirtualboxのゲストサーバ上で別々のポートで起動して確認する。
    - マスタサーバ
        - port 5433
        - DBクラスタ dbc_m
    - スタンバイサーバ（読み取り専用)
        - port 5434
        - DBクラスタ dbc_s

```

client R/W >>   [master server] -- archive log ---+
                    -p 5433                       |    
                    ~/dbc_m                       V 
                       |                    ~/archive
                 (WAL streaming)                  |
                       |                          |
                       V                          |
client R   >>   [slave  server]  <--- restore ----+
                    -p 5434
                    ~/dbc_s


```

- マスタサーバの設定
    - `initdb -D dbc_m`
    - dbc_m/postgresql.confを変更
```
listen_addresses = 'localhost'
port = 5433
wal_level = replica
archive_mode = on
archive_command = 'cp "%p" "/home/ubuntu/archive/%f"
max_wal_senders = 3
wal_keep_segments = 5
hot_standby = on
```
- archive保存先にフォルダ作成
    - mkdir ~/archive
    - (本来は信頼できるアーカイブ保存用ストレージを使用)
- replicationのための認証設定
    - dbc_m/pg_hba.confを編集
```
host    replication     repli           127.0.0.1/32            trust
```
- マスタサーバ起動
    - `pg_ctl -D dbc_m -l log_m start`
- レプリケーション接続用ユーザの作成
    - `createuser -p 5433 --replication repli`

- マスタサーバに初期データ作成
    - `psql -p 5433 postgres`
    - `CREATE TABLE hoge(col integer); INSERT INTO hoge values(1);`

- スタンバイサーバの設定
    - マスターサーバのベースバックアップ取得
        - `pg_basebackup -D dbc_s --xlog --verbose -h localhost -p 5433 -U repli`
    - dbc_s/postgresql.confの編集
```
port = 5434
```
    - recovery.confのサンプルをコピーして、編集
        - `cp /usr/local/pgsql/share/recovery.conf.sample dbc_s/recovery.conf`
```
restore_command = 'cp "/home/ubuntu/archive/%f" "%p"' 
standby_mode = on
primary_conninfo = 'host=localhost port=5433 user=repli'
```

- スタンバイサーバ起動
    - `pg_ctl -D dbc_s -l log_s start`
- スタンバイサーバに接続してデータ確認
    - `psql -p 5434 postgres`
    - `SELECT * FROM hoge`
    - `INSERTの可否`
- マスタサーバにデータを挿入し、スタンバイサーバで確認
    - `psql -p 5433 postgres`
    - `INSERT INTO hoge values(2);`
    - `psql -p 5434 postgres`
    - `SELECT * FROM hoge`
- スタンバイサーバをマスタに昇格し、データを確認
    - `pg_ctl -D dbc_s promote`
    - `psql -p 5434 postgres`
    - `SELECT * FROM hoge`
    - `INSERTの可否`
   
### 26.3 フェールオーバー

Postgresは障害を識別し、スタンバイサーバに通知するような機能は提供していない。

### 26.4 この他のログシッピングの方法

- restore_commandをポーリング的に実行する古いバージョンでの唯一の方法

### 26.5 ホットスタンバイ

- 接続を維持したまま、スタンバイから昇格

### 余談：GitLabの本番データベース喪失事件

- Publickeyの記事：<http://www.publickey1.jp/blog/17/gitlabcom56.html>
- PostgreSQLコミッタからのアドバイス:<https://yakst.com/ja/posts/4438>

- レプリケーションがなぜか遅延してる
- クリーンな状態からレプリケーションを再開しよう
- pg_basebackupのデータディレクトリが存在するからおかしいのかも？
    - データディレクトリを削除
    - それは本番環境のデータディレクトリだよ
- やばい！リストアしなきゃ！
    - pg_dumpのダンプファイルからリストア
        - pg_dumpのバージョンが古くてバックアップされてなかった
    - Azureのディスクスナップショット
        - dbサーバ対象外
    - LVMスナップショットがあったのでこれを使用

### レプリケーションはバックアップではない

- フェールオーバーのためのもの
- DELETEを間違えて発行して全データ消えてしまった
    - レプリケーションでも消えてる
    - バックアップが必要
