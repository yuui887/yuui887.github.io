# oss-template-2026
拓殖大学工学部　2026年度『オープンソースソフトウェア』の実習で使うひな形のリポジトリです．
このリポジトリから，自分の **`ユーザー名.github.io`** リポジトリを作ると，`https://ユーザー名.github.io/` に自分のサイトを公開できます（GitHub Pages）．

> **このリポジトリは，テンプレート（ひな形）です．**
> 直接 clone するのではなく，ファイルの一覧の上にある **Use this template** → **Create a new repository** で，自分のアカウントに `ユーザー名.github.io` リポジトリを作ってから使います．
> ボタンが見つからないときは，GitHubにログインしているか確認するか，[こちらのリンク](https://github.com/tomohitoy/oss-template-2026/generate)から作成画面を開いてください．
> くわしい手順は，[第7回の資料](https://github.com/tomohitoy/oss-practice-2026/blob/main-07/chap07/README.md)を見てください．
>
> （テンプレートから作った人へ：この README は，自分のサイトの説明に書きかえてかまいません）

## 公開までの流れ
1. このテンプレートから，`ユーザー名.github.io` という名前の **Public** リポジトリを作る
2. 作ったリポジトリの **Settings → Pages** で，`Deploy from a branch`・`main`・`/ (root)` になっているか確認する
3. `https://ユーザー名.github.io/` で，「準備中」のページが表示されるのを確かめる
4. リポジトリを SSH で `git clone` し，`index.html` を自分のサイトに置きかえる
5. `bash scripts/check.sh` で，公開前のチェックをする
6. `git add` → `git commit` → `git push origin main` する
7. 数分待ってから，`https://ユーザー名.github.io/` を再読み込みする

## ファイルの役割

| ファイル | 役割 | 書きかえる？ |
| --- | --- | --- |
| `index.html` | サイトのトップページ．はじめは「準備中」のページが入っています | **自分のサイトに置きかえる** |
| `404.html` | 存在しないページ（例：`https://ユーザー名.github.io/abc`）を開いたときに表示されるページ | 自由 |
| `robots.txt` | 検索エンジンへのお願い．はじめは「検索結果に載せないで」という設定です（下の説明を参照） | 自由 |
| `scripts/check.sh` | 公開前のセルフチェック（下の説明を参照） | そのまま |
| `.nojekyll` | GitHub Pages に「Jekyll で変換せず，ファイルをそのまま公開して」と伝えるための空のファイル | **消さない** |
| `.gitignore` | Gitで管理しないファイル（Macの `.DS_Store` など）の一覧 | そのまま |
| `.gitattributes` | Windows で clone しても，`scripts/check.sh` の改行コードを LF のままにする設定 | そのまま |
| `LICENSE` | ライセンス（MITライセンス）．下の説明を参照 | 下の説明を参照 |
| `README.md` | このファイル．GitHubのリポジトリのページに表示されます（サイトのページには表示されません） | 自由 |

`.` で始まるファイルは「隠しファイル」です．`ls` では表示されないので，`ls -a` で確認しましょう．

## 公開前のセルフチェック（scripts/check.sh）
リポジトリのいちばん上のフォルダで，次のコマンドを実行します．
ファイルやGitの設定は何も書きかえず，確認した結果を表示するだけです．

```bash
bash scripts/check.sh
```

表示例：
```
== 1. index.html の中身 ==
  [OK]   「準備中」のページから置きかわっています
  [OK]   <!DOCTYPE html> と </html> があります
  [OK]   文字コード（<meta charset="UTF-8">）が指定されています
  [OK]   メールアドレスのような文字列はありません
  [OK]   電話番号のような文字列はありません

== 2. GitHub Pages に必要なファイル ==
  [OK]   .nojekyll があります

== 3. コミットに記録される名前とメールアドレス（全世界から見えます） ==
         名前：taku-shoku
         メール：12345678+taku-shoku@users.noreply.github.com
  [OK]   名前が設定されています（公開してよい名前か，上の表示を確認しましょう）
  [OK]   メールアドレスは GitHub の noreply アドレスです

== 4. Git の状態 ==
  [OK]   main ブランチにいます
  [注意] まだ push していないコミットが 1 個あります
         -> git push origin main で GitHub に送りましょう

== 結果 ==
  [NG] はありません．[注意] の 1 個を確認してから進みましょう
  ※ このチェックは目安です．最後は，ブラウザで自分のサイトを見て確認しましょう
```

- **[NG]**：公開する前に，必ず直してください
- **[注意]**：問題ないか，自分の目で確認してください

## 公開する前に確認すること
このリポジトリは Public です．**サイトだけでなく，ファイルの中身・コミットの履歴・コミットに記録された名前とメールアドレスも，誰でも見ることができます．**

- [ ] 本名のフルネーム・学籍番号・住所・電話番号・メールアドレスなど，公開したくない情報が入っていない
- [ ] 自己紹介に書いていないこと（経歴・資格・受賞歴など）を，生成AIが勝手に付け足していない
- [ ] `git config user.name` と `git config user.email` が，公開してよい名前とアドレス（GitHub の noreply アドレスなど）になっている

一度 push した内容は，あとで書きかえても，コミットの履歴に残ります．
公開してはいけない情報を push してしまった場合は，すぐに教員に相談してください．

## サイトを更新するには
`index.html` を書きかえて保存したら，次のコマンドを実行します．数分でサイトに反映されます．

```bash
git add index.html
```
```bash
git commit -m "変更の内容"
```
```bash
git push origin main
```

反映されないときは，リポジトリの **Actions** タブで `pages build and deployment` が緑のチェックになっているか確認し，ブラウザで強制再読み込み（Windows：`Ctrl + F5`，Mac：`Command + Shift + R`）をしてみましょう．

## 検索エンジンに載せる？載せない？（robots.txt）
はじめの `robots.txt` は，「このサイトのページを，検索エンジンに集めないでください」という設定になっています．
サイトはURLを知っている人なら誰でも見られますが，Google などの検索結果には載りにくくなります．

検索結果に載せたくなったら，`robots.txt` を削除して，コミット → push します．

```bash
git rm robots.txt
```
```bash
git commit -m "検索エンジンに載せるため robots.txt を削除"
```
```bash
git push origin main
```

> `robots.txt` は「お願い」なので，すべての検索エンジンが守るとはかぎりません．公開したくない情報は，そもそもサイトに載せないようにしましょう．

## ライセンス（LICENSE）
`LICENSE` は，このリポジトリのファイルを，ほかの人がどんな条件で使ってよいかを示すファイルです．
このテンプレートは MIT ライセンスで公開されていて，`Copyright` の行にはテンプレートの作者の名前が書かれています．

テンプレートから作ったリポジトリで，`index.html` を自分のサイトに置きかえたら，`LICENSE` の `Copyright` の行を，自分の名前（ユーザー名）に書きかえましょう．
自分のサイトの文章を，どんな条件で使ってもらうか（MITのままにするか，ほかのライセンスにするか）は，作った人が決めることができます．

## 困ったときは

| 症状 | 原因と対処 |
| --- | --- |
| サイトを開くと `404` と表示される | ①公開に時間がかかっています．Actions タブで緑のチェックになるまで待ちましょう ②リポジトリ名が `ユーザー名.github.io` になっていません（**Settings → General** で直せます） ③**Settings → Pages** の設定を確認しましょう |
| Settings に Pages の設定が出てこない | リポジトリが Private になっています．**Settings → General** のいちばん下の **Change visibility** で Public にしましょう |
| push したのに，サイトが「準備中」のまま | Actions タブで処理が終わるまで待ち，強制再読み込みをしましょう．`git log --oneline` で `origin/main` が自分のコミットまで進んでいるかも確認しましょう |
| `bash scripts/check.sh` で `$'\r': command not found` と表示される | エディタで開いたときに，改行コードが CRLF に変わってしまっています．`rm scripts/check.sh` → `git restore scripts/check.sh` で，元のファイルを取り出し直しましょう |
| サイトの日本語が文字化けする | `index.html` の `<head>` に `<meta charset="UTF-8">` が入っているか確認しましょう |

ほかの困りごとは，[第7回の資料の「困ったときは」](https://github.com/tomohitoy/oss-practice-2026/blob/main-07/chap07/README.md#困ったときは)を見てください．
