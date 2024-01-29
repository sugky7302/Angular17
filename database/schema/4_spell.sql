create table if not exists public.spell (
    name varchar(20) primary key not null,
    description varchar(100) not null
);

comment on table public.spell is '遊戲中所有法術名稱的存放表';
comment on column public.spell.name is '唯一法術名稱。';
comment on column public.spell.description is '法術敘述。支援${tag}語法，會自動轉換成特定變數或連結。';


/* spell_knowledge 定義法術由那些知識組成。 */
create table if not exists public.spell_knowledge (
    spell varchar(20) references public.spell(name),
    knowledge varchar(20) references public.knowledge(name),
    index smallserial not null,
    is_active boolean not null default true,
    created_at timestamp not null default now(),
    updated_at timestamp not null default now(),
    primary key (spell, knowledge, index)
);

comment on table public.spell_knowledge is '法術名稱與知識的關聯表';
comment on column public.spell_knowledge.spell is '法術名稱。';
comment on column public.spell_knowledge.knowledge is '知識名稱。';
comment on column public.spell_knowledge.index is '知識在法術樹裡的編號。';
comment on column public.spell_knowledge.is_active is '是否啟用。';
comment on column public.spell_knowledge.created_at is '建立時間。';
comment on column public.spell_knowledge.updated_at is '最後更新時間，可以當作刪除的標準。';


--##############
-- 新增資料
--##############
insert into public.spell (name,description) values
    ('火球術', '將火元素凝聚為球體，以魔力為指引投擲於指定地點，造成一定範圍的燃燒。')
on conflict (name) do nothing;

insert into public.spell_knowledge(spell, knowledge) values
    ('火球術', '火元素掌握'),
    ('火球術', '球狀凝聚理論'),
    ('火球術', '魔力投擲技巧')
on conflict (spell, knowledge, index) do nothing;