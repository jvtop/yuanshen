#!/bin/bash
set -e

echo "📦 安装 Java 17 和 Git..."
sudo apt update
sudo apt install -y openjdk-17-jdk git curl gnupg ca-certificates unzip

echo "☁️ 安装 MongoDB（适配 Debian 12）..."
# 创建 keyrings 目录（防止 gpg 报错）
sudo mkdir -p /usr/share/keyrings

# 清理旧的 MongoDB 源（忽略不存在错误）
sudo rm -f /etc/apt/sources.list.d/mongodb-org-6.0.list || true
sudo rm -f /usr/share/keyrings/mongodb-server-6.0.gpg || true

# 添加 MongoDB GPG 密钥和源
curl -fsSL https://pgp.mongodb.com/server-6.0.asc | \
  sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-6.0.gpg

echo "deb [signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg] https://repo.mongodb.org/apt/debian bookworm/mongodb-org/6.0 main" | \
  sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

# 更新并安装 MongoDB
sudo apt update
sudo apt install -y mongodb-org

# 启动 MongoDB 服务
sudo systemctl start mongod
sudo systemctl enable mongod

echo "✅ MongoDB 已成功安装并启动"

echo "📥 克隆 Grasscutter 项目..."
cd ~
git clone https://github.com/Grasscutters/Grasscutter.git || true
cd Grasscutter

echo "⚙️ 开始编译 Grasscutter..."
./gradlew jar

echo "✅ 编译完成"

echo "🚀 第一次运行 Grasscutter，生成配置文件..."
java -jar build/libs/grasscutter-*.jar || true

echo ""
echo "📂 配置文件生成成功！你可以修改这些文件："
echo "  - config.json      位于 ./config/ 目录"
echo "  - resources/       资源目录"
echo ""
echo "📌 下一步你可以："
echo "  1. 修改 config/config.json 配置"
echo "  2. 准备客户端并修改 IP 地址"
echo "  3. 启动 Grasscutter："
echo ""
echo "     cd ~/Grasscutter"
echo "     java -jar build/libs/grasscutter-*.jar"
echo ""
echo "🎉 全部部署完成，欢迎进入提瓦特！"

