II. SQL言語 第7章 問い合わせ
==================

前章までで、データを入れる器となるテーブルを定義し、データを挿入し、データを更新、削除する方法を学んだ。
この章では、データを取り出す方法を学ぶ。

### 7.1 概要

- データを取り出すための処理を「問い合わせ」という
- SELECTコマンド
    - すべての列を指定する `*`
    - 計算式
    - テーブル式の省略


### 7.2 テーブル式

- FROMで取ってくる集合
    - 単純なテーブル
    - テーブルの結合
    - 条件などで変換
- 仮想テーブルが1つ作成

#### 7.2.1 FROM句

- カンマで分けられたテーブル参照リスト
    - テーブル名
    - 副問い合わせ
    - JOIN結合
- 複数のテーブル参照がある場合、クロス結合される

##### 7.2.1.1 結合テーブル

- 2つのテーブルを結合する
- 結合の酒類
    - CROSS JOIN
    - INNER JOIN
    - LEFT OUTER JOIN
    - RIGHT OUTER JOIN
    - FULL OUTER JOIN

### 練習 7-1

t1-t2テーブルを使用して、以下のSQLを試す。

- FROMでt1, t2の列挙
- CROSS JOIN
- INNER JOIN
    - ON
    - USING
    - NATURAL
- LEFT OUTER JOIN
- RIGHT OUTER JOIN
- FULL OUTER JOIN

##### 7.2.1.2 テーブルと列の別名

- 長いテーブル名を短くするなど
- 自己結合の場合は必須
- 副問い合わせの結果に別名
- 列名に対する別名
    - FROM tablename [AS] alias(column1, column2...)

##### 7.2.1.3 副問い合わせ

- SELECTの検索結果を仮想テーブルとする
- 副問い合わせにはテーブルの別名が必要
- VALUESリストを副問い合わせとできる
    - 固定値でのテーブルデータの指定


##### 7.2.1.4 テーブル関数

- スカラ値、複合データ行を返す関数
- ROWS FROMで複数の関数呼び出しを組み合わせられる
    - 関数の呼び出し結果を列として並べられる
- WITH ORDINALITYで実行結果に順序番号を振ることができる

### 練習 7-2

ROWS FROMとWITH ORDINALITYを使う。

- generate_seriesは開始と終了の範囲の整数を生成して返す組み込み関数である
    - generate_series(1, 5)  → [1, 2, 3, 4, 5]
- この関数の実行結果をテーブル関数としてFROM句に使って次の結果をSELECTせよ

| generate_series |
|:---------------:|
| 3  |
| 4  |
| 5  |
| 6  |
| 7  |

- ROWS FROMを使って次の結果をSELECTせよ
    - 2つのgenerate_seriesの結果を合わせる

| g1 | g2 |
|:--:|:--:|
| 3  |  5 |
| 4  |  6 |
| 5  |  7 |
| 6  |  NULL  |
| 7  |  NULL  |

※NULLは表記上NULLとしているだけで、そのように結果表示が得られなくても良い

- WITH ORDINALITY を使って次の結果をSELECTせよ

| g1 | g2     | ordinality |
|:--:|:------:|-----------:|
| 3  |  5     | 1          |
| 4  |  6     | 2          |
| 5  |  7     | 3          |
| 6  |  NULL  | 4          |
| 7  |  NULL  | 5          |

※NULLは表記上NULLとしているだけで、そのように結果表示が得られなくても良い

##### 7.2.1.5 LATERAL副問い合わせ

- 副問い合わせを後で実行し、先に取得したテーブル式の列を参照できるようにする
    - LATERALがないと独立した副問い合わせとして実行され、その他のFROM項目を参照できない

#### 7.2.2 WHERE句

- FROM句の処理が終わった後、検索条件と照合させる
- フィルタ的な処理

#### 7.2.3 GROUP BY句とHAVING句

- WHEREフィルタを通した後、GROUP BYでグループ化する
    - GROUP BYでグループ化した場合は、グループ化されていない列は選択リストで参照できない
    - 集約式は参照可能 
- HAVING句を使用して不要なグループを取り除く
    - WHERE は集合に対するフィルタ
    - HAVINGは、グループ化して集計した結果に対するフィルタ

### 練習 7-3

emp-dept.sqlのemp表を使って以下の結果を得るSQLを書く。

- jobをGROUP化した一覧
```
    job
-----------
 CLERK
 SALESMAN
 MANAGER
 PRESIDENT
 ANALYST
(5 rows)
```

- job別のsalの平均の一覧
- salが3000未満の社員を対象としたjob別のsalの平均の一覧
- 「salが3000未満の社員を対象としたjob別のsalの平均」が2000以上のjobの一覧

以上4つのSELECT文

#### 7.2.4 GROUPING SETS, CUBE, ROLLUP

- より複雑なGROUP化の操作

参考

```
SELECT job, deptno, SUM(sal) FROM emp GROUP BY GROUPING SETS(job, deptno)
SELECT job, deptno, SUM(sal) FROM emp GROUP BY CUBE(job, deptno)
```

#### 7.2.5 ウィンドウ関数処理

- ウィンドウ関数の処理はグループ化、集約、HAVING条件検索が行われたあとに行われる
- まずはウィンドウ関数について復習

### 練習 7-4

- ウィンドウ関数の練習
    - SELECT ename, job, sal FROM emp;
    - SELECT ename, job, sal, MAX(SAL) OVER (PARTITION BY job) FROM emp;
        - この場合の集計関数MAXはウィンドウ関数となりjobで分割された中での最大sal
    - SELECT ename, job, sal, RANK() OVER (PARTITION BY job ORDER BY sal DESC) FROM emp;
        - RANKはjobで分割された中での給与順位
- ウィンドウ関数処理の順番について確認
    - job別の最大salについて出力(A)
    - Aの結果に対してRANKをつける(B)
        - GROUP化,集約処理が処理されてから、ウィンドウ関数処理が行われている事がわかる。
    - Aの結果の最大salが3000未満の行を対象にRANKをつける ( C )
        - HAVINGが処理されてから、ウィンドウ関数処理が行われている事がわかる。
    - Bの結果から最大salが3000未満の行のみ抽出するような結果を得るにはどうしたらよいか？ (D)

```
(A)の結果
    job    |   max
-----------+---------
 CLERK     | 1300.00
 SALESMAN  | 1600.00
 MANAGER   | 2975.00
 PRESIDENT | 5000.00
 ANALYST   | 3000.00

(B)の結果
    job    |   max   | rank
-----------+---------+------
 PRESIDENT | 5000.00 |    1
 ANALYST   | 3000.00 |    2
 MANAGER   | 2975.00 |    3
 SALESMAN  | 1600.00 |    4
 CLERK     | 1300.00 |    5

(C)の結果
   job    |   max   | rank
----------+---------+------
 MANAGER  | 2975.00 |    1
 SALESMAN | 1600.00 |    2
 CLERK    | 1300.00 |    3

(D)の結果
   job    |   max   | rank
----------+---------+------
 MANAGER  | 2975.00 |    3
 SALESMAN | 1600.00 |    4
 CLERK    | 1300.00 |    5
```


