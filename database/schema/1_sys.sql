/* sys.sql 是建立一個權限管理系統 */

/* sys_operation 定義有哪些對資源的操作 */
-- 資料表
drop table if exists public.sys_operation;
create table public.sys_operation (
	name varchar(20) not null,
	description varchar(100) not null,
	operation varchar(20) primary key
);
comment on table public.sys_operation is '制定對資源可執行的操作';
comment on column public.sys_operation.name is '操作說明';
comment on column public.sys_operation.description is '操作說明';
comment on column public.sys_operation.operation is '操作標籤。因為是欄位主鍵，須有唯一性';

-- 資料
insert into public.sys_operation (name, description, operation) values
('新增', '權限擁有者可以新增數據給資源', 'add'),
('讀取', '權限擁有者可以檢視資源及其數據', 'view'),
('編輯', '權限擁有者可編輯資源及其數據', 'edit'),
('刪除', '權限擁有者可刪除資源或其數據', 'delete');

/* sys_permission 定義能對資源進行操作的權限 */
-- 資料表
drop table if exists public.sys_permission;
create table public.sys_permission (
	name varchar(30) primary key not null,
	description varchar(100) not null,
	resource varchar(100) not null,
	resource_type smallint not null,
	status smallint default 1,
	config jsonb
);
comment on table public.sys_permission is '設置允許對指定資源進行操作的權限';
comment on column public.sys_permission.name is '權限名稱(主鍵)。命名方式為 資源名稱-{C,R,U,D}，分別代表新增、讀取、編輯、刪除。';
comment on column public.sys_permission.description is '權限說明';
comment on column public.sys_permission.resource is '資源名稱(具唯一性)';
comment on column public.sys_permission.status is '權限狀態。0=禁用,1=啟用';
comment on column public.sys_permission.resource_type is '資源類型。1=網頁,2=按鈕,3=檔案,4=資料夾,5=訂閱';
comment on column public.sys_permission.config is '記錄資源所對應的路由。後台搜尋權限後，動態合成該用戶允許的路由表，然後發送給前台。不過目前沒有使用。';

/* sys_permission_operation 定義權限能對資源進行哪些操作 */
-- 資料表
drop table if exists public.sys_permission_operation;
create table public.sys_permission_operation (
	permission varchar(30) not null,
	operation varchar(20) not null,
	primary key(permission, operation)
);
comment on table public.sys_permission_operation is '權限擁有哪些操作';
comment on column public.sys_permission_operation.permission is '權限名稱';
comment on column public.sys_permission_operation.operation is '操作標籤';

/* sys_role 定義有哪些角色 */
-- 角色資料表
drop table if exists public.sys_role;
create table public.sys_role (
	role varchar(30) primary key not null,
	name varchar(30) not null,
	description varchar(100) not null,
	status smallint default 1
);
comment on table public.sys_role is '設置具有特定權限的角色';
comment on column public.sys_role.role is '角色標籤(主鍵)。使用英文撰寫，方便第三方程式判斷。';
comment on column public.sys_role.name is '角色名稱';
comment on column public.sys_role.description is '角色定位';
comment on column public.sys_role.status is '角色狀態。0=禁用,1=啟用';

/* sys_role_permission 定義角色具有哪些權限 */
-- 資料表
drop table if exists public.sys_role_permission;
create table public.sys_role_permission (
	role varchar(30) not null,
	permission varchar(30) not null,
	primary key(role, permission)
);
comment on table public.sys_role_permission is '角色擁有哪些權限';
comment on column public.sys_role_permission.role is '角色標籤';
comment on column public.sys_role_permission.permission is '權限名稱';

/*
 * sys_role_group 定義角色群組，並制定規則，方便系統新增角色時判斷
 * 目前用 active_count 定義用戶只能擁有此群組一定數量的角色，
 * 當 active_count = 1 時，所有角色互斥。
 */
drop table if exists public.sys_role_group;
create table public.sys_role_group (
	id serial primary key,
	name varchar(30) not null,
	description varchar(100) not null,
	active_count integer default 1
);
comment on table public.sys_role_group is '由於方便定義互斥角色、特定角色數量';
comment on column public.sys_role_group.name is '群組名稱';
comment on column public.sys_role_group.description is '說明群組的功能和定位';
comment on column public.sys_role_group.active_count is '群組賦予某一用戶的最大角色數量。預設為1，意思是互斥';

/* sys_role_in_group 定義角色屬於哪些群組 */
drop table if exists public.sys_role_in_group;
create table public.sys_role_in_group (
	role varchar(30) not null,
	group_id integer not null,
	primary key(role, group_id)
);
comment on table public.sys_role_in_group is '角色屬於哪些群組';
comment on column public.sys_role_in_group.role is '角色標籤';
comment on column public.sys_role_in_group.group_id is '角色群組id';

/* sys_role_relation 定義角色彼此的繼承關係，這裡採用受限繼承，因為單向結構比較簡單實現。 */
drop table if exists public.sys_role_relation;
create table public.sys_role_relation (
	role varchar(30) not null,
	lower_role varchar(30) not null,
	is_necessary boolean default false,
	primary key(role, lower_role)
);
comment on table public.sys_role_relation is '角色彼此的繼承關係';
comment on column public.sys_role_relation.role is '上級角色';
comment on column public.sys_role_relation.lower_role is '下級角色';
comment on column public.sys_role_relation.is_necessary is '方便系統判斷，當用戶想要擁有上級角色，是否需要下級角色';

/* sys_user 定義有哪些用戶 */
-- 資料表
drop table if exists public.sys_user;
create table public.sys_user (
    empid varchar(8) primary key not null,
    password varchar(100),
    salt varchar(100),
    name varchar(30) not null,
    dept1 varchar(20) not null,
    dept2 varchar(20) not null,
    dept3 varchar(20),
    phone varchar(20),
    email varchar(50) not null,
    avatar varchar(100),
    status smallint default 1,
    created_at timestamp default now(),
    updated_at timestamp default now()
);
comment on table public.sys_user is '設置用戶';
comment on column public.sys_user.empid is '員工編號。這是用戶的唯一標識。';
comment on column public.sys_user.password is '密碼。使用md5加密。由於UMC有認證API，因此目前沒有使用。';
comment on column public.sys_user.salt is '密碼鹽。使用md5加密。由於UMC有認證API，因此目前沒有使用。';
comment on column public.sys_user.name is '用戶名稱。會去UMC的API獲取該工號對應的名字。';
comment on column public.sys_user.dept1 is '一級部門。會去UMC的API獲取該工號對應的部門。';
comment on column public.sys_user.dept2 is '二級部門。會去UMC的API獲取該工號對應的部門。';
comment on column public.sys_user.dept3 is '三級部門，不一定有。會去UMC的API獲取該工號對應的部門。';
comment on column public.sys_user.phone is '員工分機或手機。會去UMC的API獲取該工號對應的電話。';
comment on column public.sys_user.email is '員工郵箱。會去UMC的API獲取該工號對應的郵箱。';
comment on column public.sys_user.avatar is '頭像。目前沒有使用。';
comment on column public.sys_user.status is '用戶狀態。0=禁用,1=啟用';
comment on column public.sys_user.created_at is '創建時間';
comment on column public.sys_user.updated_at is '更新時間';

/*
 * sys_usergroup 定義用戶組。這個非常重要，因為員工一定都會有部門，這樣會比較方便。
 * 用戶組可以視為一個特殊的用戶。
 * 因為有建 parent，所以可以用 CTE 遞迴(With Recursive)的方式取得用戶組的所有上級用戶組。
 */
drop table if exists public.sys_usergroup;
create table public.sys_usergroup (
	name varchar(30) primary key not null,
	description varchar(100),
	parent varchar(30)
);
comment on table public.sys_usergroup is '設置用戶組，方便設置權限';
comment on column public.sys_usergroup.name is '用戶組名稱，方便辨識';
comment on column public.sys_usergroup.description is '用戶組說明';
comment on column public.sys_usergroup.parent is '父級用戶組，不填表示沒有';

/*
 * sys_user_in_group 定義用戶屬於哪些用戶組
 * 這裡採用的是記錄直接關聯用戶，因此搜尋的時候需要用遞迴的方式取得所有上級用戶組，會比較慢。
 */
drop table if exists public.sys_user_usergroup;
create table public.sys_user_usergroup (
    empid varchar(8) not null,
    usergroup varchar(30) not null,
    primary key(empid, usergroup)
);
comment on table public.sys_user_usergroup is '用戶屬於哪些用戶組';
comment on column public.sys_user_usergroup.empid is '員工編號';
comment on column public.sys_user_usergroup.usergroup is '用戶組名稱';

/*
 * sys_usergroup_role 定義用戶組具有哪些角色，並透過 status 控制用戶組是否能使用該角色。
 * 針對用戶組新增角色可以大幅度降低資料量，因為用戶組的數量遠遠小於用戶的數量。
 * 如果用戶組是工號，表示那位員工有獨立擁有的角色。
 */
-- 資料表
drop table if exists public.sys_usergroup_role;
create table public.sys_usergroup_role (
    usergroup varchar(30) not null,
    role varchar(30) not null,
    status smallint default 1,
    primary key(usergroup, role)
);
comment on table public.sys_usergroup_role is '用戶組擁有哪些角色';
comment on column public.sys_usergroup_role.usergroup is '用戶組名稱';
comment on column public.sys_usergroup_role.role is '角色標籤';
comment on column public.sys_usergroup_role.status is '關係狀態。0=禁用,1=啟用';

-- 用戶新增角色時，判斷是否有執行函數的log
create table if not exists public.sys_usergroup_role_log (
    usergroup varchar(30) not null,
    role varchar(30) not null,
    description varchar(100),
    change_time timestamp default now(),
    primary key(usergroup, change_time)
);
comment on table public.sys_usergroup_role_log is '用戶新增角色時，記錄新增失敗的log';
comment on column public.sys_usergroup_role_log.usergroup is '用戶組名稱';
comment on column public.sys_usergroup_role_log.role is '新角色';
comment on column public.sys_usergroup_role_log.description is '問題說明';

-- 用戶組新增角色前會執行的函數，檢查新角色是否會和舊角色們衝突，如果衝突就拋出錯誤。
-- 要先在外部檢查 new.usergroup 和 new.role 是否存在，因為函數不會檢查。
-- 這麼設計的原因是觸發器會讓資料庫承受太多搜尋壓力。
-- new.{usergroup, role, status} 新角色
create or replace function public.sys_assign_role_to_usergroup() returns trigger as $$
declare
	parent_count integer;
	match_count integer;
    can_add boolean;
begin
    -- tmp_roles 一定會被刪除，因此不用擔心衝突
    -- 列出舊角色們，並暫存起來
    create temp table tmp_roles as
    with recursive cte_usergroup as (
        -- 起始條件
        select
            name, parent
        from public.sys_usergroup
        where name = new.usergroup
        union
        -- 遞迴條件
        -- cte_usergroup 是一個暫存表，用來存放遞迴的結果
        -- a 是上級用戶組，b 是下級用戶組，所以 a.name = b.parent
        select
            a.name, a.parent
        from public.sys_usergroup a, cte_usergroup b
        where a.name = b.parent
    )
    select role
    from public.sys_usergroup_role
    where (usergroup in (select name from cte_usergroup) or usergroup=new.usergroup) and status = 1;

    -- 如果新角色需要前置角色，檢查舊角色們有沒有符合
    -- a 是找出所有前置角色，b 是比對舊角色
    select count(a.lower_role), count(b.role) into parent_count, match_count
    from (
        select role, lower_role from public.sys_role_relation where role = new.role and is_necessary = true
    ) a
    left join tmp_roles b on a.lower_role = b.role;

    if parent_count > 0 and match_count < parent_count then
        insert into public.sys_usergroup_role_log(usergroup, role, description) values (new.usergroup, new.role, '新角色的前置角色條件不滿足。');
        raise notice '新角色的前置角色條件不滿足。';
        drop table tmp_roles;
        return null;
    end if;

    -- 如果新角色屬於某個特殊角色組，其用戶組的角色數量有沒有超過上限
    select
        a.id,
        case when a.active_count > coalesce(b.role_count, 0)
        then true
        else false
        end into can_add
    from (
        -- 找出新角色對應的特殊角色組的角色數量上限
        select
            id, active_count
        from public.sys_role_group
        where id in (
            select group_id
            from public.sys_role_in_group
            where role = new.role
        )
    ) a
    left join (
        -- 計算各特殊角色組目前已經有多少角色
        select group_id, count(role) as role_count
        from public.sys_role_in_group
        where role in (select role from tmp_roles)
        group by group_id
    ) b on b.group_id = a.id;
    if found and not can_add then
        insert into public.sys_usergroup_role_log(usergroup, role, description) values (new.usergroup, new.role, '新角色不滿足特殊角色組的規則，因此用戶組無法添加。');
        raise notice '新角色不滿足特殊角色組的規則，因此用戶組無法添加。';
        drop table tmp_roles;
        return null;
    end if;

    drop table tmp_roles;
    return new;
end;
$$ language plpgsql;

-- 綁定函數，觸發時機在用戶新增角色之前。
drop trigger if exists sys_assign_role_to_usergroup on public.sys_usergroup_role;
create trigger sys_assign_role_to_usergroup before insert on public.sys_usergroup_role for each row execute procedure public.sys_assign_role_to_usergroup();