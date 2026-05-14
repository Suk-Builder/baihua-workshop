# 白桦工坊

白桦的交互空间。墙在这里，光在这里。

## 部署方式（任选一种）

### 方式一：Docker 一键部署（推荐）

需要一台 Linux 服务器（Ubuntu/Debian/CentOS）。

```bash
# 1. 下载项目
git clone <你的仓库地址> baihua-workshop
cd baihua-workshop

# 2. 配置密钥
cp .env.example .env
nano .env
# 填入你的 DEEPSEEK_API_KEY

# 3. 一键部署
bash deploy.sh
```

部署完成后访问 `http://你的服务器IP:3456`

### 方式二：手动 Docker

```bash
cp .env.example .env
# 编辑 .env，填入密钥
docker-compose up -d
```

### 方式三：直接运行（开发/本地）

```bash
# 1. 安装依赖
npm install

# 2. 构建前端
npm run build

# 3. 设置环境变量
export DEEPSEEK_API_KEY=sk-your-key

# 4. 启动
npm start
```

访问 `http://localhost:3456`

### 方式四：VPS 裸机部署

```bash
# 安装 Node.js 20
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

# 下载项目并构建
cd /opt
git clone <仓库地址> baihua-workshop
cd baihua-workshop
npm install
npm run build

# 设置密钥
export DEEPSEEK_API_KEY=sk-your-key

# 用 PM2 守护运行
npm install -g pm2
pm2 start server.js --name baihua
pm2 startup
pm2 save

# 用 Nginx 反向代理（推荐）
# 配置域名 + HTTPS 后访问
```

## 配置说明

| 环境变量 | 必填 | 说明 |
|---------|------|------|
| `DEEPSEEK_API_KEY` | 是 | DeepSeek API 密钥 |
| `DEEPSEEK_MODEL` | 否 | 模型名，默认 `deepseek-chat` |
| `DEEPSEEK_BASE_URL` | 否 | API 地址，默认官方地址 |
| `AUTH_PASSWORD` | 否 | 访问密码，设置后需密码才能访问 |
| `PORT` | 否 | 端口，默认 `3456` |

## 安全说明

- **密钥存在服务器端**，前端代码里看不到
- 可选设置 `AUTH_PASSWORD` 防止他人访问
- 建议配合 Nginx + HTTPS 使用
- 防火墙只开放 443/80 端口

## 管理命令

```bash
# 查看日志
docker-compose logs -f

# 停止
docker-compose down

# 重启
docker-compose restart

# 更新（拉取新版本后）
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```
