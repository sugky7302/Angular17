create table if not exists public.spell (
    name varchar(20) primary key not null
);

comment on table public.spell is '遊戲中所有法術名稱的存放表';
comment on column public.spell.name is '唯一法術名稱。';


/* spell_knowledge 定義法術由那些知識組成。 */
create table if not exists public.spell_knowledge (
    spell varchar(20) references public.spell(name),
    knowledge varchar(20) references public.knowledge(name),
    is_active boolean not null default true,
    created_at timestamp not null default now(),
    updated_at timestamp not null default now(),
    primary key (spell, knowledge)
);

comment on table public.spell_knowledge is '法術名稱與知識的關聯表';
comment on column public.spell_knowledge.spell is '法術名稱。';
comment on column public.spell_knowledge.knowledge is '知識名稱。';
comment on column public.spell_knowledge.is_active is '是否啟用。';
comment on column public.spell_knowledge.created_at is '建立時間。';
comment on column public.spell_knowledge.updated_at is '最後更新時間，可以當作刪除的標準。';


/* spell_tag 定義法術名稱與標籤的關聯表，主要目的是對法術建立橫向連結，加快搜尋速度。 */
create table if not exists public.spell_tag (
    spell varchar(20) references public.spell(name),
    tag varchar(20) references public.tag(name),
    is_active boolean not null default true,
    created_at timestamp not null default now(),
    updated_at timestamp not null default now(),
    primary key (spell, tag)
);

comment on table public.spell_tag is '法術名稱與標籤的關聯表';
comment on column public.spell_tag.spell is '法術名稱。';
comment on column public.spell_tag.tag is '標籤名稱。';
comment on column public.spell_tag.is_active is '是否啟用。';
comment on column public.spell_tag.created_at is '建立時間。';
comment on column public.spell_tag.updated_at is '最後更新時間，可以當作刪除的標準。';