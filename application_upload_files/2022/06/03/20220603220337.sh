if [ ! $# -eq 1 ]; then
    echo "必须输入一个参数代表暴露端口号!"
    exit
fi
if [ -d /opt/hysteria ]; then
    rm -rf /opt/hysteria
fi
mkdir -p /opt/hysteria && cd /opt/hysteria
wget https://github.com/HyNetwork/hysteria/releases/download/v1.0.4/hysteria-linux-amd64
chmod +x hysteria-linux-amd64
password=$(head -c 32 /dev/random | base64)
cat > config.json << EOF
{
  "listen": ":$1",
  "cert": "$(pwd)/ca.crt",
  "key": "$(pwd)/ca.key",
  "obfs": "$password"
}
EOF
openssl ecparam -genkey -name prime256v1 -out ca.key
openssl req -new -x509 -days 36500 -key ca.key -out ca.crt  -subj "/CN=bing.com"
nohup ./hysteria-linux-amd64 server -config config.json > hy.log 2>&1 &
echo "hysteria server启动成功!"
echo "服务器主机: $(curl -s ifconfig.me):$1"
echo "混淆参数(密码): $password"