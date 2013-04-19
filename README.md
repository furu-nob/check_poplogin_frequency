POP3のログイン頻度を調べる。

http://www2s.biglobe.ne.jp/~nuts/labo/inti/ipt_recent.html

iptables
-m recent
--seconds 10
--hitcount 9


過去10秒間に9回以上ログインしてきたものを記録する。
