--##############
-- 資料表定義
--##############
/* tag 定義所有遊戲裡會用到的標籤，主要目的是對所有物件建立橫向連結，加快搜尋速度。 */
create table if not exists public.tag (
    name varchar(20) primary key not null,
    parent varchar(20) references public.tag(name)
);
comment on table public.tag is '遊戲中所有標籤的存放表';
comment on column public.tag.name is '唯一標籤名稱。';
comment on column public.tag.parent is '父標籤名稱。如果為空，則表示為根標籤。';


--##############
-- 新增資料
--##############