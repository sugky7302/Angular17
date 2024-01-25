import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import './globals.css';
import React from 'react';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
    title: '首頁 - 魔法工坊',
    description: '一個讓玩家著迷的魔法合成遊戲',
};

// RootLayout 是整個網站的根組件，Next.js 會從這裡開始渲染。
// 它會生成一個 HTML 文件，並將 children 渲染到 body 中。
export default function RootLayout({ children }: { children: React.ReactNode }) {
    return (
        <html lang="zh-Hant">
            <body className={inter.className}>{children}</body>
        </html>
    );
}
