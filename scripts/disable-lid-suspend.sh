#!/usr/bin/env bash
# Fedora 42 Server ─ ThinkPad W541
# フタを閉じてもサスペンドしないよう一括設定
# ---------------------------------------------
set -euo pipefail

# root 権限チェック
if [[ $EUID -ne 0 ]]; then
  echo "このスクリプトは root で実行してください（sudo でも可）" >&2
  exit 1
fi

CONF_DIR=/etc/systemd/logind.conf.d
CONF_FILE=$CONF_DIR/10-lid.conf

echo ">>> systemd-logind の設定を書き込み中…"
mkdir -p "$CONF_DIR"
cat >"$CONF_FILE" <<'EOF'
[Login]
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
EOF

echo ">>> サスペンド／ハイバネート系ターゲットを無効化（任意）…"
systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

echo ">>> systemd-logind を再起動…"
systemctl restart systemd-logind

echo "設定完了: ふたを閉じてもサスペンドしません。"

