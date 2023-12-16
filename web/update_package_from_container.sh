#! /bin/bash
# 這個腳本是要把 container 的檔案更新到本地端
# 設計這個腳本是因為 docker-compose 的 volumes 會修改檔案的使用者和群組，導致 pnpm 無法安裝依賴包。
# 如果強制使用 chown root:root 又會破壞 web-prd 的運作，所以只好用這個腳本來更新檔案。
# Author: Arvin Yang
# Date: 2023/12/16

# 這個腳本必須在 web 目錄下執行
my_dir="/home/user/project/my/my-chat/web/"
echo "***Copy files in the Container Web into host machine***"
echo "Copying .vscode"
docker cp web:/app/.vscode/ $my_dir
echo "Copying PNPM"
docker cp web:/app/pnpm-lock.yaml $my_dir
docker cp web:/app/package.json $my_dir
echo "Copying Next.js"
docker cp web:/app/tsconfig.json $my_dir
docker cp web:/app/next.config.js $my_dir
echo "Copying linter"
docker cp web:/app/.eslintrc.json $my_dir
docker cp web:/app/.prettierrc.json $my_dir
echo "Copying Renderers"
docker cp web:/app/postcss.config.js $my_dir
docker cp web:/app/tailwind.config.ts $my_dir
echo "Copying Playwright"
docker cp web:/app/playwright-ct.config.ts $my_dir
echo "***It's done***"