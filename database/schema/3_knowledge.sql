--##############
-- 資料表定義
--##############
/* knowledge 是遊戲中裝備、技能等功能的基底。 */
create table if not exists public.knowledge (
    name varchar(20) primary key not null,
    description varchar(100) not null
);
comment on table public.knowledge is '遊戲中所有知識的存放表';
comment on column public.knowledge.name is '唯一知識名稱。';
comment on column public.knowledge.description is '知識說明。';


/* knowledge_tag 定義知識與標籤的關聯表，主要目的是對知識建立橫向連結，加快搜尋速度。 */
create table if not exists public.knowledge_tag (
    knowledge varchar(20) references public.knowledge(name),
    tag varchar(20) references public.tag(name),
    is_active boolean not null default true,
    created_at timestamp not null default now(),
    updated_at timestamp not null default now(),
    primary key (knowledge, tag)
);

comment on table public.knowledge_tag is '知識與標籤的關聯表';
comment on column public.knowledge_tag.knowledge is '知識名稱。';
comment on column public.knowledge_tag.tag is '標籤名稱。';
comment on column public.knowledge_tag.is_active is '是否啟用。';
comment on column public.knowledge_tag.created_at is '建立時間。';
comment on column public.knowledge_tag.updated_at is '最後更新時間，可以當作刪除的標準。';


--##############
-- 新增資料
--##############
