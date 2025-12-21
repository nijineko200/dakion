#!/bin/bash
echo "--- 不眠モード起動：4分おきに通信します ---"
echo "--- ブラウザ（Firefox）を閉じるとこの通信も止まります ---"

while true; do
  # Firefoxコンテナが動いているかチェック
  if [ "$(docker inspect -f '{{.State.Running}}' my-browser 2>/dev/null)" == "true" ]; then
    echo "Staying alive... $(date)"
    # 4分ごとに通知
    sleep 240
  else
    echo "--- Firefoxが停止しました。生存確認を終了します ---"
    break
  fi
done
