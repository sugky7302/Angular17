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
insert into public.knowledge (name, description) values
    ('火元素掌握', '火系法師們必須學會的基本功。'),
    ('球狀凝聚理論', '一門如何將魔力凝聚、塑形為水滴狀的球體的基礎理論。'),
    ('魔力投擲技巧', '一種能夠將魔力剝離並投擲到指定地點的戰鬥技巧。')
on conflict (name) do nothing;

insert into public.knowledge_tag(knowledge, tag) values
    ('火元素掌握', '火焰'),
    ('球狀凝聚理論', '球體'),
    ('魔力投擲技巧', '投射物')
on conflict(knowledge, tag) do nothing;
