II. SQL言語 第8章 データ型
==================


### 8.1 数値データ型

- サイズごとに様々ある
- 1バイト整数(tinyint)やunsignedはない
- numeric 可変長 精度固定
- 連番 auto_increment的な
    - integer + seq -> serial

### 8.2 通過型

ロケール依存

### 8.3 文字型

- char
- varchar
- text

**PostgreSQLにおいては**3つの文字列で内部実装は同じで、長さ制限があるかないか、空白文字の処理が行われるかの違いがあるだけ。（他のDBMSではcharが固定長の格納領域で高速なことがある）PostgreSQLにおいてはcharはほとんど利点はない。

### 8.4 バイナリ列データ型

- bytea

- 文字列はロケール処理が行われるが、バイナリ列はバイト列そのもの。
- BLOB相当

### 8.5 日付/時刻データ型

- timestamp 
    - ある時点の日付時刻
    - with timezoneでタイムゾーン付きで記録
- date
    - 日付のみ
- time
    - 時刻のみ
- interval
    - 時間間隔


#### 8.5.1 日付/時刻の入力

- ISO8601など一般的な文字列で受け付けられる
- typeで明示

#### 8.5.4 特別な値

- now, todayなど

#### 練習 8-1

- 当日を 'YYYY Mon DD'の書式で文字列として出力
    - [9.8 データ書式設定関数 参照](http://www.postgresql.jp/document/9.6/html/functions-formatting.html)
- 当日の3日後を出力
    - [9.9 日付時刻関数 参照](http://www.postgresql.jp/document/9.6/html/functions-datetime.html)


### 8.6 論理値データ型

- boolean
- 有効なリテラル値
    - TRUE
    - 't'
    - 'true'
    - 'y'
    - 'yes'
    - 'on'
    - '1'

### 8.7 列挙型

- いわゆるenum
- CREATE TYPEで定義
- ディスク上で4バイト

### 8.8 幾何データ型

- 2次元空間オブジェクト
    - 地理情報
    - ドロー系描画情報
    - レコメンデーション
- データ型として持つ意味
    - 豊富な幾何関数、演算子


#### 練習 8-2

- 2点 (0, 0) , (5, 4)間の距離を算出
    - [9.11 幾何関数と演算子 参照](http://www.postgresql.jp/document/9.6/html/functions-geometry.html)
- 中心 (3,3)半径5の円と、中心(10,10)半径5の円が重なりを持つか
   

### 8.9 ネットワークアドレス型

IPv4, IPv6, MACアドレスを格納するデータ型

### 8.10 ビット列データ型

ビットマスクなど

### 8.11 テキスト検索に関する型

全文検索用

### 8.12 UUID型

UUIDの格納

### 8.13 XML型

XMLの格納

### 8.14 JSONデータ型

- テキストとして保持するjson型
    - 有効なjsonテキストとして保持
    - キーの順番や重複したキーもそのまま
- バイナリ形式で保持するjsonb型
    - 解析済みのバイナリとして保持で高速化
    - 格納時に若干のオーバーヘッド
    - インデックスサポート
- ほとんどの場合jsonb型でOK
- 柔軟なデータ構造で格納できるがなんでもJSONにいれるのはマズい **整合性に注意**
    - なんでもJSONにしてよいわけはない
- [jsonb用の豊富な演算子・関数](http://www.postgresql.jp/document/9.6/html/functions-json.html#functions-json-op-table)
    - `->` 要素取り出し(jsonオブジェクトとして)
    - `->>` 要素取り出し(textとして)
    - `@>` トップレベルで包含
- jsonbインデックス
- SQLとしての文字列リテラルとJSONとしての文字列リテラルを混同しないように
    

#### 練習 8-3

sql/json_test.sql を実行し、3万件の書籍データを作成する。

```
     Table "public.books"
 Column |  Type   | Modifiers
--------+---------+-----------
 id     | integer | not null
 name   | text    |
 price  | integer |
 info   | jsonb   |
Indexes:
    "books_pkey" PRIMARY KEY, btree (id)


 id | name  | price |                                              info

----+-------+-------+--------------------------------------------------------------------------------------
  1 | book1 | 45745 | {"size": 28370, "tags": ["rossian", "game", "fassion", "money", "kids"], "format": "text"}
  2 | book2 |  1266 | {"size": 28014, "tags": ["japanese", "comic", "science", "music", "kids"], "format": "pdf"}
...
```


info列を使った検索を行う。

- priceが1100以下でformatがpdfのbookを検索
    - 18件
- tagsに japanese, comic, science, nature をすべて含むbook
    - 8件
- analayze後に上記のtags検索の実行計画を確認
    - EXPLAIN
- info列にGINインデックスを作成後再び実行計画の確認
    - `CREATE INDEX idx_books_info ON books USING GIN(info);`
    - Bitmap Indexが使用され、コスト下がっていることを確認


