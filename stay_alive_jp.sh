#!/bin/bash
echo "=========================================="
echo "   🚀 日本語対応・接続維持モード 起動中   "
echo "   (4分ごとに生存確認を送出します)        "
echo "=========================================="

while true; do
  # Firefoxが動いているかチェック
  if [ "$(docker inspect -f '{{.State.Running}}' my-browser 2>/dev/null)" == "true" ]; then
    echo "--- [$(date '+%H:%M:%S')] 接続を維持しています... ---"
    sleep 240
  else
    echo "--- [!] Firefoxが停止したため、終了します ---"
    break
  fi
done
