#!/bin/bash

# 1. コンテナの起動
docker restart my-browser my-guacamole || {
  docker run -d --name my-browser --network host -e VNC_PASSWORD="" -e DISABLE_VNC_AUTH=1 -e LANG=ja_JP.UTF-8 jlesage/firefox
  docker run -d --name my-guacamole --network host -v guac-settings:/config oznu/guacamole
  docker exec -u 0 my-browser apk add --no-cache font-ipa
}

# 2. 【重要】1分待機してから維持スクリプトをバックグラウンドで開始
(
  sleep 60
  echo "--- [$(date)] iPad維持モード開始 ---" >> /workspaces/dakion/stay_alive.log
  while true; do
    if [ "$(docker inspect -f '{{.State.Running}}' my-browser 2>/dev/null)" == "true" ]; then
      # 接続維持の証拠をログに残す
      echo "Keep-alive: $(date)" >> /workspaces/dakion/stay_alive.log
      sleep 240
    else
      echo "Firefox stopped. Exiting." >> /workspaces/dakion/stay_alive.log
      break
    fi
  done
) &
