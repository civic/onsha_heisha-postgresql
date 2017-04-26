III. サーバの管理 第25章 バックアップとリストア
==================


### 25.1 SQLによるダンプ

- pg_dump dbname > outfile
- pg_dumpは新しいバージョンのPostgreSQLにロード可能
- 内部的に整合性がある


#### 25.1.1 ダンプのリストア

- psql dbname < infile
- データベースは作成されないので別途作成すること
    - データベース内のオブジェクトをを所有するユーザも必要
    - テンプレートで作成されたオブジェクトもダンプされるので、template0から作成する
- 失敗すると途中までリストアされたものになる
    - `--single-transaction`で1つのトランザクションとしてロード可能
- ANALYZEコマンドで統計情報の更新

#### 25.1.2 pg_dumpallの使用

- pg_dumpはデータベース単位
    - ロールやテーブル空間はクラスタ単位なので出力されない
- pg_dumpallはクラスタ単位でバックアップ
- pg_dumpall > outfile

#### 25.1.3 大規模データベース

- pg_dumpは標準出力に書きだすのでパイプで圧縮したりできる
- pg_dumpのカスタム書式で独自形式で出力可能
    - 特定のテーブルのみ復元可能
    - psqlではリストアできないpg_restore
- `-F`でフォーマット指定可能
    - plain
    - custom
    - directory
    - tar
- `-j`で並列度を指定可能

#### 練習 25-1

データベースのdump/restoreを試す。
カスタム形式から特定の要素のみリストアする。

- 準備
    - データベースdb1, db2, db3をそれぞれ作成する
    - db1に sql/emp-dept.sql の内容をロード
- db1からplain形式でdb2に全部リストア
    -  db1からplainダンプファイルを書き出し、db2にロードする
        - pg_dump db1 > db1.sql
        - psql db2 < db1.sql
- db1からカスタム形式ダンプファイルを作成し、empのみをdb3にロード
    - pg_dump --format=custom > db1.dump
    - db1.dumpのアーカイブ一覧を確認する
        - pg_restore --list db1.dump
    - `--table`オプションでempテーブルのみdb3にロードする
        - pg_restore --table=emp --dbname=db3 db1.dump
    - db3のempテーブルを確認する
        - \d emp
        - primery key
        - 外部キー制約
- empテーブルの主キーをリストアし忘れた。アーカイブ要素を指定して追加リストア
    - アーカイブ一覧をファイルに出力し、empテーブル以外の項目を残したファイルを作成
        - pg_restore --list db1.dump > listfile
        - listfile編集し、empの主キー要素のみ残す
        - pg_restore --use-list=listfile --dbname=db3 db1.dump

### 25.2 ファイルシステムレベルのバックアップ

- サーバ停止状態でデータベースクラスタのフォルダをまるごとコピー
- 特定のデータベース、テーブルのみなどはできない
- pg_dumpよりはサイズが大きいが高速

### 25.3 継続的アーカイブとポイントインタイムリカバリ(PITR)

- 先行書き込みログ (write ahead logging, WAL)
    - トランザクションログ、ジャーナルファイル
- WALについては[30章参照](30-wal.md)
- WALを使用してバックアップの第3の戦略
    − ファイルシステムレベルのバックアップとWALの組み合わせ
    − WALの再生を任意時点で停止することで、ポイントインタイムリカバリ(タイムマシンのように)

