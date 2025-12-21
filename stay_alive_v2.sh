#!/bin/bash
echo "=========================================="
echo "   🛡️  接続検知型・不眠モード 起動中"
echo "   (iPadで接続中のみ 4分おきに通信します)"
echo "=========================================="

while true; do
  # VNC接続(5900番)があるかチェック
  # ssコマンドで接続中(ESTAB)の数を確認
  CONNECTION_COUNT=$(ss -ant | grep :5900 | grep ESTAB | wc -l)

  if [ "$CONNECTION_COUNT" -gt 0 ]; then
    echo "--- [$(date '+%H:%M:%S')] 接続を検知 ($CONNECTION_COUNT台)。維持しています... ---"
    sleep 240
  else
    echo "--- [$(date '+%H:%M:%S')] 接続が切れました。不眠モードを終了します。 ---"
    break
  fi
done
