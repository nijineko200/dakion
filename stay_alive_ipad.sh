#!/bin/bash
echo "=== iPad操作維持モード 実行中 (4分間隔) ==="
while true; do
  if [ "$(docker inspect -f '{{.State.Running}}' my-browser 2>/dev/null)" == "true" ]; then
    echo "--- [$(date '+%H:%M:%S')] 接続を維持しています ---"
    sleep 240
  else
    echo "--- Firefox停止につき終了 ---"
    break
  fi
done
