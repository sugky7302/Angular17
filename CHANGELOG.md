# 更新日誌

## Unreleased - 2024-01-12
- 調整權限管理資料表結構。

## [0.2.0] - 2023-12-16
- 導入 TailWindCSS、PostCSS、Flowbite、PlayWright、Prettier、ESLint、Firebase、Redux、RxJS。([#5024def][5024def])([#de023e2][de023e2])([#ddf4238][ddf4238])
- 導入 GitHub Actions 作為 CI/CD 工具。([#b4b6b8c][b4b6b8c])
- 建置本地 PlayWright 容器和 GitHub Actions 測試腳本。([#5502e70][5502e70])
- 使用容器 web-deploy 架設 Nginx 伺服器。([#e034ad1][e034ad1])
- 修正沒有安裝 postcss-import、postcss-nesting，導致 Playwright 測試失敗的問題。([#c5e872a][c5e872a])

[0.2.0]: b860f0a7e1838f90cf7d70ce749c9bf84c9f7be2
[ddf4238]: https://github.com/sugky7302/my-chat/commit/ddf4238353bc5b3f7eec10fb813d80446d767294
[de023e2]: https://github.com/sugky7302/my-chat/commit/de023e22a668d673fd269380d9f0134b20bfc318
[c5e872a]: https://github.com/sugky7302/my-chat/commit/c5e872a48ffa908100a71c4653819ee670579698
[e034ad1]: https://github.com/sugky7302/my-chat/commit/e034ad1f125f9143aef042aac5e7621f8499bc35
[5502e70]: https://github.com/sugky7302/my-chat/commit/5502e70e0454a52483383c081109d8457cb734c2
[b4b6b8c]: https://github.com/sugky7302/my-chat/commit/b4b6b8c0097fa6eafcd1784e65597bfc0e788487
[5024def]: https://github.com/sugky7302/my-chat/commit/5024def75579b6c71ca97f31b8fedd5c8b0b1bc


## 0.1.0 - 2023-12-13
- 建置 React 環境。
- 設置初始化環境和開發環境。