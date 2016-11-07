#目的

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

#必要なもの

* mysql
* python
  * requests
  * bs4 (BeautifulSoup)
  * mysql-connector

#使用方法

~~~
getDpc.py 西暦年 報告ページURL
~~~

例：
~~~
getDpc.py 2014 http://www.mhlw.go.jp/stf/shingi2/0000104146.html
~~~

#テーブル構造

~~~
hospitals
  year
  nr
  oldnr
  name

disname
  did
  dname

tr1
  year
  did
  withop1
  withtr1
  cases
  days
  
tr2
  year
  did
  withop1
  withtr1
  cases
  days
~~~

