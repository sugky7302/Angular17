# 我的 Side Project - 魔法工坊
設計一個現代化的介面實現技能合成、裝備管理等等遊戲功能。另外一個目標是學習 React 怎麼寫。

## 網頁
使用 [Next.js] + [TailWindCSS] + [PostCSS] + [Flowbite] + [PlayWright] + [Prettier] + [ESLint] + [Firebase] + [Redux] + [RxJS]。原本要用 [Husky]，但是我用 [GitHub Actions] 取代。
自定義組件必須大寫開頭，不然 Next.js 沒辦法引用。
Next.js 使用 Webpack + SWC(~= ESbuild, written by Rust)，已經很快了，不用再挑其他工具。
Next.js 就是 Qwik 在 React 的實現。

### 建立新的 Router
Next.js 會根據 {router}/page.tsx 建立組件，網址搜尋就是 http(s):// xxx/{router}。

### 怎麼實現 /:a/xxx
建一個資料夾叫 `[a]`，Next.js 看到**中括號**就會擷取它，然後你可以在程式裡用 `param.a` 抓取這個參數。
如果使用 `[...b]`，Next.js 會把所有網址都塞在 `param` 裡面。
注意！如果要取得 `param`，請在程式碼第一行加上 `"use client";`。

### **/layout.tsx 的用途
layout.tsx 就是提供一個公用畫面給同目錄的　page.tsx 或者它的子路由，這樣就能夠拆分組件跟畫面，而且子路由也可以跟父路由放在同一層，參考[這裡][Qwik Layout]。
如果子路由裡面也有 layout.tsx，它只會渲染在父路由的 layout.tsx 裡面。

### (name) 資料夾的用途
如果你希望建立很多個路由，但是彼此只有資料面的不同，畫面都是共用的，那第一個選項肯定是共用 layout.tsx。在 Next.js 裡，解決方案就是建立一個資料夾 `(name)`，然後添加 layout.tsx 和子路由在裡面。舉個例子：
```
(a)
 |- layout.tsx
 |- b/
 |  |- page.tsx
 |- c/
 |  |- page.tsx
```
這個時候，網頁只要輸入 `http://xxx.xxx.xxx.xxx:~/b` 就可以導入 `(a)/b/page.tsx`，而且這個組件是使用 `(a)/layout.tsx` 當作畫面。同理可得，`http://xxx.xxx.xxx.xxx:~/c` 可以導入 `(a)/c/page.tsx`。

### 如何導入自訂 CSS
在 .tsx 裡面寫上 `import styles from 'xxx.css'`，然後在想要導入的元素寫上 `className={styles.{your class} }` 就可以了。

[Next.js]: https://nextjs.org/docs/pages/api-reference/create-next-app
[TailWindCSS]: https://tailwindcss.com/docs/guides/nextjs
[PostCSS]: https://hackmd.io/@FortesHuang/S1I2iF7v5
[Flowbite]: https://flowbite.com/docs/getting-started/next-js/
[PlayWright]: https://playwright.dev/docs/intro
[Prettier]: https://github.com/tailwindlabs/prettier-plugin-tailwindcss
[ESLint]: https://blog.devgenius.io/eslint-prettier-typescript-and-react-in-2022-e5021ebca2b1
[Firebase]: https://medium.com/tomsnote/%E4%BD%BF%E7%94%A8firebase%E4%BD%9C%E7%82%BAreact%E7%9A%84%E8%B3%87%E6%96%99%E5%BA%AB-b61af2333526
[Husky]: https://jenniesh.github.io/dev/NPM/husky-lint-staged/
[GitHub Actions]: https://docs.github.com/zh/actions
[Redux]: https://redux.js.org/introduction/getting-started
[RxJS]: https://react-rxjs.org/docs/getting-started
[Qwik Layout]: https://qwik.tw/qwikcity/layout/overview/
[Next.js Tutor]: https://www.youtube.com/watch?v=GowPe3iiqTs