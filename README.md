# WeChat Selkies

[![WeChat-Selkies](https://img.shields.io/badge/dynamic/regex?url=https%3A%2F%2Fgithub.com%2FSeanSuny%2FWeChat-Selkies&search=WeChat-Selkies&logo=github&label=GitHub)](https://github.com/SeanSuny/WeChat-Selkies)
[![GitHub License](https://img.shields.io/github/license/SeanSuny/wechat-selkies?logo=github&color=limegreen)](https://github.com/SeanSuny/wechat-selkies/blob/master/LICENSE)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/SeanSuny/wechat-selkies/docker-wechat.yml?logo=github-actions&label=Build)](https://github.com/SeanSuny/wechat-selkies/actions/workflows/docker-wechat.yml)
[![Docker version](https://img.shields.io/docker/v/seansuny/wechat-selkies?logo=docker&label=Version&color=green)](https://hub.docker.com/r/seansuny/wechat-selkies)
[![Docker stars](https://img.shields.io/docker/stars/seansuny/wechat-selkies?logo=docker&label=Stars&color=blue)](https://hub.docker.com/r/seansuny/wechat-selkies)
[![Docker Pulls](https://img.shields.io/docker/pulls/seansuny/wechat-selkies?logo=docker&label=Pulls&color=blue)](https://hub.docker.com/r/seansuny/wechat-selkies)
[![Docker Image Size](https://img.shields.io/docker/image-size/seansuny/wechat-selkies?logo=docker&label=amd64%20Size&arch=amd64&color=orange)](https://hub.docker.com/r/seansuny/wechat-selkies)
[![Docker Image Size](https://img.shields.io/docker/image-size/seansuny/wechat-selkies?logo=docker&label=arm64%20Size&arch=arm64&color=orange)](https://hub.docker.com/r/seansuny/wechat-selkies)

基于 Docker 的 微信 Linux 客户端，使用 Selkies WebRTC 技术提供浏览器访问支持。

## 项目简介

本项目将官方 微信 Linux 客户端封装在 Docker 容器中，通过 Selkies 技术实现在浏览器中直接使用微信，无需在本地安装微信客户端。

## 快速开始

### docker run 部署

Docker Hub镜像：

```bash
docker run -it -p 3001:3001 -v ./config:/config --device /dev/dri:/dev/dri seansuny/wechat-selkies:latest
```

### docker-compose 部署

1. **创建项目目录并进入**

   ```bash
   mkdir wechat-selkies
   cd wechat-selkies
   ```

2. **创建 docker-compose.yml 文件**

   ```yaml
    services:
      wechat-selkies:
        image: seansuny/wechat-selkies:latest
        container_name: wechat-selkies
        ports:
          - "3001:3001"
        restart: unless-stopped
        volumes:
          - ./config:/config
        devices:
          - /dev/dri:/dev/dri
        environment:
          - PUID=1000
          - PGID=1000
          - TZ=Asia/Shanghai
          - LC_ALL=zh_CN.UTF-8
          - AUTO_START_WECHAT=true
          # - CUSTOM_USER=<Your Name>
          # - PASSWORD=<Your Password>
        shm_size: "1gb"
    ```

3. **启动服务**

   ```bash
   docker-compose up -d
   ```

#### 访问微信

   在浏览器中访问：`https://localhost:3001` 或 `https://<服务器IP>:3001`

#### 环境变量配置

在 `docker-compose.yml` 中可以配置以下环境变量：

| 变量名 | 默认值 | 说明 |
| --- | --- | --- |
| TITLE | WeChat Selkies | Web UI 标题 |
| PUID | 1000 | 用户 ID |
| PGID | 1000 | 组 ID |
| TZ | Asia/Shanghai | 时区设置 |
| LC_ALL | zh_CN.UTF-8 | 语言环境 |
| CUSTOM_USER | - | 自定义用户名（推荐设置） |
| PASSWORD | - | Web UI 访问密码（推荐设置） |
| AUTO_START_WECHAT | true | 是否自动启动微信客户端 |

#### 数据卷挂载

- `./config:/config`: 微信配置和数据持久化目录
- `shm_size: "1gb"`: 共享内存建议1G-2G

#### 硬件加速

如果您的系统支持 GPU 硬件加速，Docker Compose 配置中已包含相关设备映射：

```yaml
devices:
  - /dev/dri:/dev/dri
```
