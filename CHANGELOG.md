# 更新日誌

## Unreleased - 2024-02-01
### Added:
- 新增 tag 資料表，用標籤橫向連結所有物件。([#def94d8][def94d8])
- 新增 knowledge 資料表，儲存遊戲內的知識。([#def94d8][def94d8])
- 新增 spell 資料表，儲存遊戲法術。([#4904710][4904710])
- 新增 knowledge_tag 資料表，記錄知識有哪些標籤。([#4904710][4904710])
- 新增 spell_knowledge 資料表，定義法術由那些知識組成的。([#4904710][4904710])
- 新增行為樹。
    - 定義基本節點。([#f093bce][f093bce])

### Changed:
- 調整權限管理資料表結構。([#6b1af67][6b1af67])
- 把清除舊表的動作統一在 `0_init.sql` 裡面執行。([#def94d8][def94d8])

[f093bce]: https://github.com/sugky7302/my-chat/commit/f093bce4a9f77599d347b7f971c4f608232e542e
[4904710]: https://github.com/sugky7302/my-chat/commit/490471034befc51ef7500c17f4eac57f43f4b34d
[def94d8]: https://github.com/sugky7302/my-chat/commit/def94d8bb11bd03b228445e8a4f83ea92865250c
[6b1af67]: https://github.com/sugky7302/my-chat/commit/6b1af674965185be0434ad058243261d9ce04b0f

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