#!/bin/bash
# 既存のコンテナを掃除して再起動
docker rm -f my-browser my-guacamole 2>/dev/null
docker run -d --name my-browser --network host -e VNC_PASSWORD="" -e DISABLE_VNC_AUTH=1 -e LANG=ja_JP.UTF-8 jlesage/firefox
docker run -d --name my-guacamole --network host -v guac-settings:/config oznu/guacamole
docker exec -u 0 my-browser apk add --no-cache font-ipa
# 不眠対策スクリプト
cat << 'INNER' > stay_alive_v2.sh
#!/bin/bash
while true; do
  CONNECTION_COUNT=$(ss -ant | grep :5900 | grep ESTAB | wc -l)
  if [ "$CONNECTION_COUNT" -gt 0 ]; then sleep 240; else break; fi
done
INNER
chmod +x stay_alive_v2.sh
nohup ./stay_alive_v2.sh > /dev/null 2>&1 &
