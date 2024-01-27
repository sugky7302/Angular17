drop table if exists public.knowledge;
drop table if exists public.knowledge_tag;


create table if not exists public.knowledge (
    name varchar(20) primary key not null,
    description varchar(100) not null,
    created_at timestamp not null default now(),
    updated_at timestamp not null default now()
);
comment on table public.knowledge is '遊戲中所有知識的存放表';
comment on column public.knowledge.name is '唯一知識名稱。';
comment on column public.knowledge.description is '知識說明。';
comment on column public.knowledge.created_at is '建立時間。';
comment on column public.knowledge.updated_at is '更新時間。';


create table if not exists public.knowledge_tag (
    knowledge varchar(20) references public.knowledge(name),
    tag varchar(20) references public.tag(name),
    primary key (knowledge, tag)
);

comment on table public.knowledge_tag is '知識與標籤的關聯表';
