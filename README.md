# BaiHua Workshop

> An AI-powered conversational web application — "The wall is here, the light is here." A personal AI companion built with DeepSeek API, featuring streaming dialogue, warm amber/stone design, and a focus on meaningful interaction.

[![React](https://img.shields.io/badge/React-19-61DAFB)](https://react.dev/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.0-blue)](https://www.typescriptlang.org/)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-3.4-38B2AC)](https://tailwindcss.com/)
[![Node.js](https://img.shields.io/badge/Node.js-20%2B-green)](https://nodejs.org/)

## Overview

**BaiHua Workshop** (白桦工坊) is a full-stack AI chat application designed as a personal interactive space. It demonstrates production-grade deployment patterns: Docker containerization, PM2 process management, Nginx reverse proxy with SSL, and comprehensive access controls.

**Live Demo**: [https://suk-baihua.top/baihua](https://suk-baihua.top/baihua) (password-protected)

## Features

- **Streaming AI dialogue**: Real-time SSE-based conversation with DeepSeek model
- **Warm, intentional design**: Amber/stone color palette — deliberately not generic SaaS blue
- **Responsive layout**: Optimized for both mobile and desktop
- **Password protection**: Optional `AUTH_PASSWORD` for access control
- **Docker deployment**: One-command setup with `deploy.sh`
- **Production hardened**: PM2 + Nginx + SSL + firewall restrictions

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | React 19, Vite, TypeScript, Tailwind CSS, shadcn/ui |
| Backend | Node.js, Express |
| AI | DeepSeek API (deepseek-chat) |
| Deployment | Docker, Docker Compose, PM2 |
| Proxy | Nginx with SSL termination |

## Quick Start

### Docker (Recommended)

```bash
git clone https://github.com/Suk-Builder/baihua-workshop.git
cd baihua-workshop
cp .env.example .env
# Edit .env: add your DEEPSEEK_API_KEY
bash deploy.sh
```

### Local Development

```bash
npm install
npm run build
cp .env.example .env
npm start
# http://localhost:3456
```

## Configuration

| Variable | Required | Description |
|----------|----------|-------------|
| `DEEPSEEK_API_KEY` | Yes | DeepSeek API key |
| `DEEPSEEK_MODEL` | No | Default: `deepseek-chat` |
| `DEEPSEEK_BASE_URL` | No | Default: official endpoint |
| `AUTH_PASSWORD` | No | Access password (optional) |
| `PORT` | No | Default: `3456` |

## Deployment Architecture

```
User → Nginx (443/SSL) → localhost:3456 → Express → DeepSeek API
              ↓
         Basic Auth (optional)
         Firewall: only 80/443 open
```

## Security Features

- API key stored server-side only, never exposed to frontend
- Optional password authentication via `AUTH_PASSWORD`
- Nginx HTTPS with SSL certificate
- Firewall: only ports 80/443 exposed; app binds to `127.0.0.1:3456`
- `.env` file with `chmod 600` permissions

## Management Commands

```bash
# View logs
docker-compose logs -f

# Restart
docker-compose restart

# Update
docker-compose down
docker-compose build --no-cache
docker-compose up -d

# PM2 (bare metal)
pm2 start server.js --name baihua
pm2 save
pm2 startup
```

## About

Part of the [Suk-Builder](https://github.com/Suk-Builder) ecosystem. Built by Ying Momo, targeting Germany's digital health and AI market via the Chancenkarte program.

## License

MIT
