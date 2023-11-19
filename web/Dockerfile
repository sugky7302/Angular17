# syntax=docker/dockerfile:1.3

##########################################
# 全域變數
# Alpine 只有 3.15~3.16 才有 Node.js 16
##########################################
ARG ALPINE_VERSION=3.18 \
    NODE_VERSION=20.9.0 \
    ANGULAR_VERSION=17.0.1 \
    NGINX_VERSION=1.25.3 \
    PNPM_DIR="/usr/local/lib/node_modules/pnpm"


###########
# 建置套件
###########
FROM alpine:${ALPINE_VERSION} AS build-package
ARG ANGULAR_VERSION \
    MODE \
    PNPM_DIR


ENV PNPM_HOME=${PNPM_DIR} \
    PATH="${PNPM_DIR}:$PATH"

WORKDIR /usr/src/app

COPY package.json .

# 安裝 NodeJS 和 NPM
# gyp 需要 python、make、g++，所以要額外安裝
RUN --mount=type=cache,id=nodejs,target=/var/cache/apk \
    set -xe; \
    apk add --update nodejs npm python3 make g++; \
    ln -sf python3 /usr/bin/python;

# 安裝 PNPM、Angular CLI、依賴包
RUN --mount=type=cache,target=/usr/local/cache/.pnpm-store \
    set -xe; \
    npm i -g pnpm; \
    # 設定全域安裝路徑
    pnpm config set global-bin-dir ${PNPM_HOME}; \
    # 設定快取路徑
    pnpm config set store-dir "/usr/local/cache/.pnpm-store"; \
    pnpm i -g @angular/cli@${ANGULAR_VERSION}; \
    if [ "${TOML_ENV}" == "dev" ]; then \
        pnpm install; \
    else \
        pnpm install --production; \
    fi


##########
# 開發環境
##########
FROM node:${NODE_VERSION} AS dev
ARG PNPM_DIR
ENV PNPM_HOME=${PNPM_DIR} \
    PATH="${PNPM_DIR}:$PATH"

WORKDIR /app

# 複製 PNPM
COPY --from=build-package /usr/local/lib/node_modules/ /usr/local/lib/node_modules/
# 複製套件
COPY --from=build-package /usr/src/app .
# 加入 pnpm 的 bin 路徑
RUN echo "alias pnpm='${PNPM_HOME}/bin/pnpm.cjs'" >> /root/.bashrc

CMD ["tail", "-f", "/dev/null"]


##########
# 產品環境
##########
FROM dev as prd
COPY angular.json tsconfig.app.json tsconfig.json ./
COPY src/ /app/src

RUN --mount=type=cache,target=/usr/local/cache/.pnpm-store \
    set -xe; \
    cp /app/src/environments/environment.prd.ts /app/src/environments/environment.ts; \
    ng build;
    # if [ -d "/app/dist/scripts" ]; then \
    #     rm -rf dist/scripts; \
    # fi; \
    # make dist/scripts; \
    # cp node_modules/marked/marked.min.js dist/scripts/; \
    # cp node_modules/.pnpm/prismjs@1.29.0/node_modules/prismjs/prism.js dist/scripts/; \
    # cp node_modules/.pnpm/emoji-toolkit@7.0.0/node_modules/emoji-toolkit/lib/js/joypixels.min.js dist/scripts/
CMD ["tail", "-f", "/dev/null"]

# 因為進入容器時會遇到 「需要 Alpine Linux ARM64 3.9 或較新的版本」 這個問題
# 所以我把 Nginx 的版本從 1.15.2-alpine 升級成 1.23.4-alpine
# Arvin Yang - 2023/05/17
# FROM nginx:1.23.4-alpine as prd
# COPY --from=build /app/dist /usr/share/nginx/html

# # 把 Nginx 模版複製到 Nginx 的設定檔目錄
# COPY docker-required/nginx.template /etc/nginx/conf.d/

# # 把切割 Nginx 的 access.log 的腳本複製到 Logrotate 的設定檔目錄
# COPY docker-required/logrotate.template /etc/logrotate.d/default.conf

# # 啟動時，把環境變數帶入 Nginx 的設定檔
# CMD envsubst '${BACKEND_URI}${FAB8F_URI}${WEATHER_8T_URI}' < /etc/nginx/conf.d/nginx.template > /etc/nginx/conf.d/default.conf && exec nginx -g 'daemon off;'