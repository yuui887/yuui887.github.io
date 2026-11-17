#!/usr/bin/env bash
# =============================================================================
# 公開前のセルフチェック
#
#   使い方：このリポジトリのいちばん上のフォルダで，次のコマンドを実行します
#     bash scripts/check.sh
#
#   ファイルやGitの設定は，何も書きかえません（確認して表示するだけです）．
#   [NG]   ：公開する前に，必ず直してください
#   [注意] ：問題ないか，自分の目で確認してください
# =============================================================================

# このスクリプトがある scripts フォルダの1つ上（リポジトリのいちばん上）に移動する
cd "$(dirname "$0")/.." || exit 1

ng_count=0    # [NG] の数
note_count=0  # [注意] の数

ok()   { printf '  [OK]   %s\n' "$1"; }
note() { printf '  [注意] %s\n' "$1"; note_count=$((note_count + 1)); }
ng()   { printf '  [NG]   %s\n' "$1"; ng_count=$((ng_count + 1)); }
hint() { printf '         -> %s\n' "$1"; }

# -----------------------------------------------------------------------------
echo "== 1. index.html の中身 =="
# -----------------------------------------------------------------------------
if [ ! -f index.html ]; then
  ng "index.html がありません"
  hint "第6回で作った index.html をコピーしましょう（第7回 4-D）"
else
  # テンプレートの「準備中」のページには，目印のコメントが入っている
  if grep -q 'oss-template-2026:placeholder' index.html; then
    ng "index.html が「準備中」のページのままです"
    hint "第6回で作った index.html に置きかえましょう（第7回 4-D）"
  else
    ok "「準備中」のページから置きかわっています"
  fi

  if grep -qi '<!doctype html>' index.html && grep -qi '</html>' index.html; then
    ok "<!DOCTYPE html> と </html> があります"
  else
    ng "<!DOCTYPE html> か </html> が見つかりません"
    hint "AIの回答をコピーするときに，最初か最後が欠けていないか確認しましょう"
  fi

  if grep -qiE "charset=[\"']?utf-8" index.html; then
    ok "文字コード（<meta charset=\"UTF-8\">）が指定されています"
  else
    ng "文字コードの指定（<meta charset=\"UTF-8\">）がありません．文字化けするかもしれません"
    hint "<head> のすぐ下に <meta charset=\"UTF-8\"> を追加しましょう"
  fi

  # メールアドレスのような文字列
  emails=$(grep -oE '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' index.html | sort -u)
  if [ -n "$emails" ]; then
    note "メールアドレスのような文字列があります．公開してよいものか確認しましょう"
    printf '%s\n' "$emails" | sed 's/^/           /'
  else
    ok "メールアドレスのような文字列はありません"
  fi

  # 電話番号のような文字列（090-1234-5678，03-1234-5678，09012345678 など）
  phones=$(grep -oE '0[0-9]{1,4}-[0-9]{1,4}-[0-9]{3,4}|0[789]0[0-9]{8}' index.html | sort -u)
  if [ -n "$phones" ]; then
    note "電話番号のような文字列があります．公開してよいものか確認しましょう"
    printf '%s\n' "$phones" | sed 's/^/           /'
  else
    ok "電話番号のような文字列はありません"
  fi

  # 第6回の依頼文では「画像ファイルと JavaScript は使わない」と頼んでいる
  if grep -qi '<script' index.html; then
    note "JavaScript（<script>）が入っています．AIが依頼文の条件を守らなかったのかもしれません"
  fi
  if grep -qi '<img' index.html; then
    note "画像（<img>）を表示しようとしています．画像ファイルはリポジトリにないので，表示されません"
  fi
fi

# -----------------------------------------------------------------------------
echo ""
echo "== 2. GitHub Pages に必要なファイル =="
# -----------------------------------------------------------------------------
if [ -f .nojekyll ]; then
  ok ".nojekyll があります"
else
  ng ".nojekyll がありません．GitHub Pages が Jekyll でファイルを変換してしまいます"
  hint "touch .nojekyll で作り直して，コミットしましょう"
fi

# Gitのリポジトリの中でなければ，ここで終わり
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo ""
  ng "ここはGitのリポジトリではありません"
  hint "git clone したフォルダ（ユーザー名.github.io）の中で実行しましょう"
  exit 1
fi

# -----------------------------------------------------------------------------
echo ""
echo "== 3. コミットに記録される名前とメールアドレス（全世界から見えます） =="
# -----------------------------------------------------------------------------
name=$(git config user.name)
email=$(git config user.email)
echo "         名前：${name:-（未設定）}"
echo "         メール：${email:-（未設定）}"

if [ -z "$name" ]; then
  ng "名前（user.name）が設定されていません"
  hint "第7回 4-C を見て設定しましょう"
elif printf '%s' "$name" | LC_ALL=C grep -q '[^ -~]'; then
  note "名前に日本語が入っています．本名のフルネームなら，ユーザー名に変えることをおすすめします（第7回 4-C）"
else
  ok "名前が設定されています（公開してよい名前か，上の表示を確認しましょう）"
fi

case "$email" in
  "")
    ng "メールアドレス（user.email）が設定されていません"
    hint "第7回 4-C を見て，GitHub の noreply アドレスを設定しましょう"
    ;;
  *@users.noreply.github.com)
    ok "メールアドレスは GitHub の noreply アドレスです"
    ;;
  *)
    note "メールアドレスが GitHub の noreply アドレスではありません．公開してよいアドレスか確認しましょう"
    hint "第7回 4-C を見て，noreply アドレスに変えることをおすすめします"
    ;;
esac

# まだ push していないコミットに，noreply 以外のアドレスが記録されていないか
if git rev-parse --verify -q origin/main >/dev/null; then
  others=$(git log --format='%ae' origin/main..HEAD | grep -v '@users.noreply.github.com$' | sort -u)
  if [ -n "$others" ]; then
    note "まだ push していないコミットに，次のアドレスが記録されています"
    printf '%s\n' "$others" | sed 's/^/           /'
    hint "4-C の設定のあとで，git commit --amend --reset-author --no-edit を実行すると，直前のコミットを作り直せます"
  fi
fi

# -----------------------------------------------------------------------------
echo ""
echo "== 4. Git の状態 =="
# -----------------------------------------------------------------------------
branch=$(git rev-parse --abbrev-ref HEAD)
if [ "$branch" = "main" ]; then
  ok "main ブランチにいます"
else
  note "いまは $branch ブランチにいます．GitHub Pages で公開されるのは main ブランチです"
fi

changes=$(git status --porcelain)
if [ -n "$changes" ]; then
  note "まだコミットしていない変更があります"
  printf '%s\n' "$changes" | sed 's/^/           /'
  hint "git add ファイル名 → git commit -m \"メッセージ\" でコミットしましょう"
fi

if git rev-parse --verify -q origin/main >/dev/null; then
  ahead=$(git rev-list --count origin/main..HEAD)
  if [ "$ahead" -gt 0 ]; then
    note "まだ push していないコミットが ${ahead} 個あります"
    hint "git push origin main で GitHub に送りましょう"
  elif [ -z "$changes" ]; then
    ok "GitHub（origin/main）と同じ状態です"
  fi
fi

# -----------------------------------------------------------------------------
echo ""
echo "== 結果 =="
# -----------------------------------------------------------------------------
if [ "$ng_count" -gt 0 ]; then
  echo "  [NG] が ${ng_count} 個あります．直してから push しましょう"
  exit 1
elif [ "$note_count" -gt 0 ]; then
  echo "  [NG] はありません．[注意] の ${note_count} 個を確認してから進みましょう"
else
  echo "  すべてOKです！"
fi
echo "  ※ このチェックは目安です．最後は，ブラウザで自分のサイトを見て確認しましょう"
