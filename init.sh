#!/bin/bash



# factorio 下载 URL
URL="https://factorio.com/get-download/stable${VERSION:+/$VERSION}/headless/linux64"
LOCAL_FILE="/app/linux64"  # 原始下载文件路径


# 检查文件是否存在
if [ ! -f "$LOCAL_FILE" ]; then
    echo "文件不存在，正在下载最新版本......"
    curl -L "$URL" -o "$LOCAL_FILE"
    echo "文件下载完成"
else
    echo "文件已存在"
    if [ "$FORCE_UPDATE" == "true" ]; then
        echo "已开启强制更新，正在下载最新文件......"
        curl -L "$URL" -o "$LOCAL_FILE"
        echo "文件下载完成"
    fi
fi





#解压文件
echo "解压文件......"
rm -rf /app/linux64.tar.xz
cp /app/linux64 /app/linux64.tar.xz
tar -xJf /app/linux64.tar.xz --overwrite



# 检查并复制 map-gen-settings.json
if [ ! -f /app/factorio/data/map-gen-settings.json ]; then
    echo "map-gen-settings.json does not exist, copying from example..."
    cp /app/factorio/data/map-gen-settings.example.json /app/factorio/data/map-gen-settings.json
fi

# 检查并复制 map-settings.json
if [ ! -f /app/factorio/data/map-settings.json ]; then
    echo "map-settings.json does not exist, copying from example..."
    cp /app/factorio/data/map-settings.example.json /app/factorio/data/map-settings.json
fi

# 检查并复制 server-settings.json
if [ ! -f /app/factorio/data/server-settings.json ]; then
    echo "server-settings.json does not exist, copying from example..."
    cp /app/factorio/data/server-settings.example.json /app/factorio/data/server-settings.json
fi

# 检查并复制 server-whitelist.json
if [ ! -f /app/factorio/data/server-whitelist.json ]; then
    echo "server-whitelist.json does not exist, copying from example..."
    cp /app/factorio/data/server-whitelist.example.json /app/factorio/data/server-whitelist.json
fi

chmod +x /app/factorio/bin/x64/factorio
echo "检测是否存在存档$SAVES"
if [ ! -f /app/factorio/saves/$SAVES ]; then
    echo "未检测到存档 $SAVES，正在自动生成中......"
    /app/factorio/bin/x64/factorio --create /app/factorio/saves/$SAVES && echo "存档 ${SAVES} 生成成功"
else
    echo "存档 ${SAVES} 已存在"
fi
echo "正在启动服务器"
exec /app/factorio/bin/x64/factorio --port $PORT \
    --start-server $SAVES \
    --map-gen-settings $MAP_GEN_SETTINGS_CONFIG \
    --map-settings $MAP_SETTINGS_CONFIG \
    --server-settings $SERVER_SETTINGS_CONFIG \
    ${SERVER_WHITELIST:+--server-whitelist $SERVER_WHITELIST}