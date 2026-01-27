FROM seansuny/baseimage-selkies-slim:latest

# 必须在这里声明，以便下方的 RUN 指令可以使用
ARG TARGETPLATFORM
ARG BUILD_DATE
ARG VERSION
USER root

# 元数据标签
LABEL org.opencontainers.image.title="WeChat Selkies"
LABEL org.opencontainers.image.description="WeChat Linux client in browser via Selkies WebRTC"
LABEL org.opencontainers.image.authors="Sean"
LABEL org.opencontainers.image.source="https://github.com/SeanSuny/wechat-selkies"
LABEL org.opencontainers.image.documentation="https://github.com/SeanSuny/wechat-selkies#readme"
LABEL org.opencontainers.image.vendor="WeChat Selkies Project"
LABEL org.opencontainers.image.licenses="GPL-3.0-only"
LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.version=$VERSION

# 设置环境变量
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    # [微信运行必需的底层库]
    libatk1.0-0 libatk-bridge2.0-0 libatomic1 libc6 libcairo2 libcups2 \
    libdbus-1-3 libfontconfig1 libgbm1 libgcc1 libgdk-pixbuf-xlib-2.0-0 libglib2.0-0 \
    libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 \
    libx11-xcb1 libxcb1 libxcb-glx0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 \
    libxcb-randr0 libxcb-render0 libxcb-render-util0 libxcb-shape0 libxcb-shm0 \
    libxcb-sync1 libxcb-util1 libxcb-xfixes0 libxcb-xinerama0 libxcb-xkb1 \
    libxcomposite1 libxdamage1 libxext6 libxfixes3 libxi6 libxkbcommon-x11-0 \
    libxrandr2 libxrender1 libxss1 libxtst6 \
    # [辅助工具]
    shared-mime-info desktop-file-utils python3-tk stalonetray && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 2. 根据架构下载并安装微信
RUN case "$TARGETPLATFORM" in \
    "linux/amd64") \
        WECHAT_URL="https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.deb" ;; \
    "linux/arm64") \
        WECHAT_URL="https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_arm64.deb" ;; \
    *) \
        echo "❌ Unsupported platform: $TARGETPLATFORM"; exit 1 ;; \
    esac && \
    echo "📦 Downloading WeChat for $TARGETPLATFORM..." && \
    curl -fsSL -o /tmp/wechat.deb "$WECHAT_URL" && \
    apt-get update && \
    apt-get install -y --no-install-recommends /tmp/wechat.deb && \
    rm -f /tmp/wechat.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 3. 配置 Openbox (隐藏托盘留白)
RUN sed -i '/<dock>/,/<\/dock>/s/<noStrut>no<\/noStrut>/<noStrut>yes<\/noStrut>/' /etc/xdg/openbox/rc.xml

# 4. 环境变量设置
ENV TITLE="WeChat" \ 
    TZ="Asia/Shanghai" \
    LC_ALL="zh_CN.UTF-8" \
    AUTO_START_WECHAT="true"

# 5. 更新 WebUI 上的图标为微信图标
RUN cp /usr/share/icons/hicolor/128x128/apps/wechat.png /usr/share/selkies/www/icon.png

# 复制自定义启动脚本 
COPY /assets/wechat /

# 保持端口和卷映射
EXPOSE 3001
VOLUME /config