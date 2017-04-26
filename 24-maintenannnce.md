III. サーバの管理 第24章 定常的なデータベース保守作業
==================


- 定期的なバックアップ
- 定期的なバキューム
- 定期的なログファイル管理

### 24.1 定常的なバキューム作業

多くのインストレーションでは自動バキュームデーモンにおまかせで十分


#### 24.1.1 バキューム作業の基本

- PostgreSQLは追記型なので更新・削除された行は残っている
    - VACUUMによって再利用可能に
    - 統計情報の更新
    - 可視性マップの更新
    - トランザクションIDの周回
- 標準VACUUMとVACUUM FULL

#### 24.1.2 ディスク容量の復旧

- VACUUMしてもOSに領域を返却はしない。(FULLはする)
- 自動バキュームデーモンは、更新作業に反応して動的に計画する
    - 自分で固定周期のバキュームを計画するよりよい

#### 24.1.3 プランナ用の統計情報の更新

適切な問い合わせ計画を作成するためにテーブルの内容に関する統計情報を使用する

- ANALYZEによって収集
- 自動バキュームデーモンが有効の場合はテーブル内容の更新量によって自動的に発行

#### 24.1.4 可視性マップの更新

- トランザクションによって見えるデータ、見えないデータがある
- インデックスオンリースキャン
    - インデックスだけみてデータを返す（データをスキャンしない）
    - インデックスがすべて可視であれば可能

#### 24.1.5 トランザクションIDの周回エラーの防止

- トランザクションID(XID)の比較によってなりたつ
- 新しいXIDはより未来の行
- 周回した時に古いXIDが未来のXIDになる
- 古い20億のXIDと新しい20億のXID
- ??

#### 24.1.6 自動バキュームデーモン

- VACUUMとANALYZEの自動化
- 大量のタプルの挿入、更新、削除があったテーブルを検査
- 様々なパラメータにしたがって、変更時に自動バキュームが発動

### 24.2 定常的なインデックスの再作成

- インデックスページの再構築をおこなう
- REINDEXはテーブルの排他ロックを使う
    - CREATE INDEXのほうが良い場合がある

### 24.3 ログファイルの保守

- postgresql.confのlogging_collector設定
- 外部のログローテーションプログラムの使用 apacheのrotatelogs
- syslog
- ログの切り替えをしても削除は行わないので別途設定が必要
