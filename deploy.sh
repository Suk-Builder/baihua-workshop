#!/bin/bash
# 白桦工坊 - 一键部署脚本
# 支持 Ubuntu/Debian/CentOS + Docker 部署

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PROJECT_NAME="baihua-workshop"
PORT=3456

echo -e "${GREEN}=== 白桦工坊 一键部署 ===${NC}"
echo ""

# 检查 root 权限
if [ "$EUID" -ne 0 ]; then 
    echo -e "${YELLOW}建议使用 root 权限运行，否则可能遇到权限问题${NC}"
fi

# 1. 安装 Docker（如果没有）
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}正在安装 Docker...${NC}"
    curl -fsSL https://get.docker.com | sh
    systemctl enable docker
    systemctl start docker
    echo -e "${GREEN}Docker 安装完成${NC}"
else
    echo -e "${GREEN}Docker 已安装${NC}"
fi

# 安装 docker-compose（如果没有）
if ! command -v docker-compose &> /dev/null; then
    echo -e "${YELLOW}正在安装 docker-compose...${NC}"
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    echo -e "${GREEN}docker-compose 安装完成${NC}"
else
    echo -e "${GREEN}docker-compose 已安装${NC}"
fi

# 2. 检查 .env 文件
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}创建 .env 配置文件...${NC}"
    cp .env.example .env
    echo -e "${RED}请编辑 .env 文件，填入你的 DEEPSEEK_API_KEY${NC}"
    echo "然后重新运行此脚本"
    exit 1
fi

# 检查密钥是否已设置
if grep -q "DEEPSEEK_API_KEY=sk-" .env; then
    echo -e "${GREEN}API 密钥已配置${NC}"
else
    echo -e "${RED}请先在 .env 文件中设置 DEEPSEEK_API_KEY${NC}"
    exit 1
fi

# 3. 构建并启动
echo -e "${YELLOW}正在构建白桦工坊...${NC}"
docker-compose build --no-cache

echo -e "${YELLOW}正在启动...${NC}"
docker-compose up -d

# 4. 检查状态
sleep 3
if curl -s http://localhost:$PORT/api/health > /dev/null; then
    echo ""
    echo -e "${GREEN}=== 部署成功！==="
    echo ""
    echo -e "访问地址: http://$(curl -s ifconfig.me 2>/dev/null || echo '你的服务器IP'):$PORT${NC}"
    echo ""
    echo "管理命令："
    echo "  查看日志: docker-compose logs -f"
    echo "  停止服务: docker-compose down"
    echo "  重启服务: docker-compose restart"
    echo ""
else
    echo -e "${RED}部署可能有问题，请检查日志: docker-compose logs${NC}"
    exit 1
fi
