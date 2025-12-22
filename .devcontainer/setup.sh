#!/bin/bash

# 1. コンテナの再起動（または作り直し）
docker restart my-browser my-guacamole || {
  docker run -d --name my-browser --network host -e VNC_PASSWORD="" -e DISABLE_VNC_AUTH=1 -e LANG=ja_JP.UTF-8 jlesage/firefox
  docker run -d --name my-guacamole --network host -v guac-settings:/config oznu/guacamole
  docker exec -u 0 my-browser apk add --no-cache font-ipa
}

# 2. バックグラウンドで「1分待機」と「維持スクリプト」を実行
(
  sleep 60
  
  # 維持スクリプト本体の作成（パスを固定）
  cat << 'INNER_EOF' > /workspaces/dakion/stay_alive_ipad.sh
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
INNER_EOF

  chmod +x /workspaces/dakion/stay_alive_ipad.sh
  # 実行ログをファイルに保存
  /workspaces/dakion/stay_alive_ipad.sh > /workspaces/dakion/stay_alive.log 2>&1
) & 
