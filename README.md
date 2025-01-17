# 目的

このプロジェクトは、中央社会保険医療協議会診療報酬調査専門組織ＤＰＣ評価分科会の「DPC導入の影響評価に関する調査」報告ページの資料をダウンロードしてきて
使いやすいようにデータベースに落とすことを目的としています。

たとえば、

http://www.mhlw.go.jp/stf/shingi/0000056344.html

http://www.mhlw.go.jp/stf/shingi2/0000104146.html

を見に行くと、次のような問題があることがわかります

1. 病院に振られているIDが、年度ごとに変わる。
1. 一覧・集計したいデータが、２０個以上のファイルに分割されている。しかも、Excel。
1. 合計・平均はあるが、一次データであるはずの件数はそこから逆算しなければいけない。

これらを、一括してデータベースに格納することにより、経年比較や集計が手軽に行えるようになることが期待されます。

# 必要なもの

* mysql
* python (3.x)
  * requests
  * bs4 (BeautifulSoup)
  * mysql-connector (mysql-connector-python3)
  * xlrd (python3-xlrd)

# 使用方法

~~~
getDpc.py 西暦年 報告ページURL
~~~

例：
~~~
getDpc.py 2014 http://www.mhlw.go.jp/stf/shingi2/0000104146.html
~~~

注意：
* データは「古い順」に読み込まないと、共通病院 ID の割り振りに失敗します。

# テーブル構造

|hospitals|病院テーブル|
|:--|:--|
|id|病院ID （内部で振られるユニークID）|
|year|西暦年|
|nr|その年の病院番号|
|oldnr|前の年の病院番号|
|name|病院名|

|disname|病気テーブル|
|:--|:--|
|did|病気ID|
|dname|病気名|

|tr1|処置１有無テーブル|
|:--|:--|
|year|西暦年|
|nr|病院番号（西暦年依存）|
|did|病気ID|
|withop|手術の有無(0/1)|
|withtr1|処置１の有無(0/1)|
|cases|件数|
|days|入院日数（合計数）|

|tr2|処置２有無テーブル|
|:--|:--|
|year|西暦年|
|nr|病院番号（西暦年依存）|
|did|病気ID|
|withop|手術の有無(0/1)|
|withtr2|処置２の有無(0/1)|
|cases|件数|
|days|入院日数（合計数）|

# リンク
- [平成２９年度 2017](https://www.mhlw.go.jp/stf/shingi2/0000196043_00001.html)
- [平成２８年度 2016](https://www.mhlw.go.jp/stf/shingi2/0000196043.html)
- [平成２７年度 2015](https://www.mhlw.go.jp/stf/shingi2/0000150723.html)
- [平成２６年度 2014](https://www.mhlw.go.jp/stf/shingi2/0000104146.html)
- [平成２５年度 2013](https://www.mhlw.go.jp/stf/shingi2/0000104146.html)
- [平成２４年度 2012](https://www.mhlw.go.jp/stf/shingi/0000023522.html)
- [平成２３年度 2011](https://www.mhlw.go.jp/stf/shingi/0000023522.html) （現在非対応のフォーマット）
