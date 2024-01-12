--##############
-- 清空舊有資料表
-- 由於部分資料表有使用外部鍵，因此在這裡定義。
--##############
-- 操作被合併到 sys_permission，這邊只是清除舊表。
drop table if exists public.sys_permission_operation;
drop table if exists public.sys_role_group;
drop table if exists public.sys_role_relation;
drop table if exists public.sys_role_in_group;
-- 以上表格不再使用
drop table if exists public.sys_usergroup_role_log;
drop table if exists public.sys_role_permission;
drop table if exists public.sys_user_usergroup;
drop table if exists public.sys_usergroup_role;
drop table if exists public.sys_user_role;
drop table if exists public.sys_user_permission;
drop table if exists public.sys_usergroup_permission;
drop table if exists public.sys_permission;
drop table if exists public.sys_resource_explorer;
drop table if exists public.sys_resource;
drop table if exists public.sys_operation;
drop table if exists public.sys_role;
drop table if exists public.sys_user;
drop table if exists public.sys_usergroup;
drop trigger if exists sys_assign_role_to_usergroup on public.sys_usergroup_role;




--##############
-- 資料表定義
--##############
/* sys_operation 定義有哪些對資源的操作 */
create table if not exists public.sys_operation (
	name varchar(20) not null,
	description varchar(100) not null,
	operation varchar(20) primary key
);
comment on table public.sys_operation is '制定對資源可執行的操作';
comment on column public.sys_operation.name is '操作說明';
comment on column public.sys_operation.description is '操作說明';
comment on column public.sys_operation.operation is '操作標籤。因為是欄位主鍵，須有唯一性';

-- 把 C,R,U,D 拆開來是因為網頁端需要比較細緻的控制，例如只能新增不能刪除。
-- subscribe 從 read 獨立出來是因為搜尋比較方便，特別是要找出哪些屬於訂閱類型的權限，都用 read 還要切資源名稱。
insert into public.sys_operation (name, description, operation) values
('讀取', '權限擁有者可以檢視資源及其數據', 'read'),
('新增', '權限擁有者可以新增數據給資源', 'create'),
('編輯', '權限擁有者可編輯資源及其數據', 'update'),
('刪除', '權限擁有者可刪除資源或其數據', 'delete'),
('訂閱', '權限擁有者可訂閱資源或其數據。當內容更新時，會通知使用者。', 'subscribe'),
('賦予', '權限擁有者可賦予其他人擁有此資源的權限', 'grant')
ON CONFLICT (operation) DO NOTHING;


/* sys_resource 定義有哪些資源，主要設置相簿。
   id 請使用 資源類型-資源名稱-{UTF8-SHA256 -> substr(12)}(資源類型-資源名稱) */
create table if not exists public.sys_resource (
    id varchar(100) primary key not null,
    name varchar(100) not null,
    owner varchar(30) not null,
    type integer default 1,
    status smallint default 1 CHECK(status > -1 and status < 2),
    created_at timestamp default now(),
    updated_at timestamp default now()
);
comment on table public.sys_resource is '定義有哪些資源，主要用在使用者新建相簿。';
comment on column public.sys_resource.id is '資源編號(主鍵)，請使用 資源類型-資源名稱-{UTF8-SHA256 -> substr(12)}(資源類型-資源名稱)。';
comment on column public.sys_resource.name is '資源名稱';
comment on column public.sys_resource.type is '資源類型。1=公開相簿，2=受保護的相簿';
comment on column public.sys_resource.owner is '擁有者。可能是部門、個人或者系統建立的（system）。';
comment on column public.sys_resource.status is '資源狀態。0=禁用,1=啟用';
comment on column public.sys_resource.created_at is '創建時間';
comment on column public.sys_resource.updated_at is '最後更新時間，可以當作刪除的標準。';


/* sys_resource_explorer 是記錄資源擁有哪些實體檔案（照片）或者子資源。
   這個主要目的是讓系統了解使用者建立的「虛擬」相簿和實體照片（CameraGrabHist or uplload_history）的關係。 */
create table if not exists public.sys_resource_explorer (
    resource varchar(100) references public.sys_resource(id),
    target_type smallint default 1 CHECK (target_type > 0),
    target varchar(100) not null,
    status smallint default 1 CHECK(status > -1 and status < 2),
    created_at timestamp default now(),
    updated_at timestamp default now(),
    primary key(resource, target_type, target)
);
comment on table public.sys_resource_explorer is '記錄資源擁有哪些實體檔案（照片）或者子資源。';
comment on column public.sys_resource_explorer.resource is '資源編號';
comment on column public.sys_resource_explorer.target_type is '目標類型。1=實體檔案，2=子資源';
comment on column public.sys_resource_explorer.target is '目標編號。可能是實體檔案名稱（含副檔名）或子資源的編號。';
comment on column public.sys_resource_explorer.status is '關係狀態。0=禁用,1=啟用';
comment on column public.sys_resource_explorer.created_at is '創建時間';
comment on column public.sys_resource_explorer.updated_at is '最後更新時間，可以當作刪除的標準。';


/* sys_permission 定義能對資源進行操作的權限
   每一個權限 = 對某一項資源允許一個指定操作
   或者把權限當作「標籤」使用，例如不要訂閱某些東西
   部門或者個人照片已經記錄在 CameraGrabHist，這種就不用額外記錄了。 */
create table if not exists public.sys_permission (
	name varchar(30) primary key not null,
	description varchar(100) not null,
	resource varchar(100) references public.sys_resource(id),
	operation varchar(20) references public.sys_operation(operation),
	status smallint default 1 CHECK(status > -1 and status < 2),
    created_at timestamp default now(),
    updated_at timestamp default now()
);
comment on table public.sys_permission is '設置允許對指定資源進行操作的權限';
comment on column public.sys_permission.name is '權限名稱(主鍵)。命名方式為 資源類型-資源名稱-操作前幾個字母大寫。';
comment on column public.sys_permission.description is '權限說明';
comment on column public.sys_permission.resource is '資源名稱(具唯一性)，外鍵允許填入NULL';
comment on column public.sys_permission.operation is '操作名稱(具唯一性)，外鍵允許填入NULL';
comment on column public.sys_permission.status is '權限狀態。0=禁用,1=啟用';
comment on column public.sys_permission.created_at is '創建時間';
comment on column public.sys_permission.updated_at is '最後更新時間，可以當作刪除的標準。';


/* sys_role 定義有哪些角色 */
create table if not exists public.sys_role (
	role varchar(30) primary key not null,
	name varchar(30) not null,
	description varchar(100) not null,
	status smallint default 1 CHECK(status > -1 and status < 2),
    created_at timestamp default now(),
    updated_at timestamp default now()
);
comment on table public.sys_role is '設置具有特定權限的角色';
comment on column public.sys_role.role is '角色標籤(主鍵)。角色定位-角色名稱，使用英文撰寫，方便第三方程式判斷。';
comment on column public.sys_role.name is '角色名稱';
comment on column public.sys_role.description is '角色定位';
comment on column public.sys_role.status is '角色狀態。0=禁用,1=啟用';
comment on column public.sys_role.created_at is '創建時間';
comment on column public.sys_role.updated_at is '最後更新時間，可以當作刪除的標準。';


/* sys_role_permission 定義角色具有哪些權限 */
create table if not exists public.sys_role_permission (
	role varchar(30) references public.sys_role(role),
	permission varchar(30) references public.sys_permission(name),
    status smallint default 1 CHECK(status > -1 and status < 2),
    created_at timestamp default now(),
    updated_at timestamp default now(),
	primary key(role, permission)
);
comment on table public.sys_role_permission is '角色擁有哪些權限';
comment on column public.sys_role_permission.role is '角色標籤';
comment on column public.sys_role_permission.permission is '權限名稱';
comment on column public.sys_role_permission.status is '角色狀態。0=禁用,1=啟用';
comment on column public.sys_role_permission.created_at is '創建時間';
comment on column public.sys_role_permission.updated_at is '最後更新時間，可以當作刪除的標準。';

/* sys_user 定義有哪些用戶 */
-- 資料表
create table if not exists public.sys_user (
    id varchar(20) primary key not null,
    password varchar(100),
    salt varchar(100),
    name varchar(30) not null,
    dept1 varchar(20) not null,
    dept2 varchar(20) not null,
    dept3 varchar(20) default '',
    phone varchar(20),
    email varchar(50) not null,
    avatar varchar(100),
    status smallint default 1 CHECK(status > -1 and status < 2),
    created_at timestamp default now(),
    updated_at timestamp default now()
);
comment on table public.sys_user is '設置用戶';
comment on column public.sys_user.id is '員工編號。這是用戶的唯一標識。';
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


/* sys_user_role 定義用戶擁有哪些角色
   解決每次都要先建立 usergroup 再建立 role 的問題 */
create table if not exists public.sys_user_role (
	user_id varchar(20) references public.sys_user(id),
	role varchar(30) references public.sys_role(role),
    status smallint default 1 CHECK(status > -1 and status < 2),
    created_at timestamp default now(),
    updated_at timestamp default now(),
	primary key(user_id, role)
);
comment on table public.sys_user_role is '用戶擁有哪些角色';
comment on column public.sys_user_role.role is '角色標籤';
comment on column public.sys_user_role.user_id is '員工編號';
comment on column public.sys_user_role.status is '關係狀態。0=禁用,1=啟用';
comment on column public.sys_user_role.created_at is '創建時間';
comment on column public.sys_user_role.updated_at is '最後更新時間，可以當作刪除的標準。';


/* sys_user_permission 定義用戶具有哪些權限
   這個具有最高權限，主要是解決用戶的私人資料夾、相簿或檔案。 */
create table if not exists public.sys_user_permission (
	user_id varchar(20) references public.sys_user(id),
	permission varchar(30) references public.sys_permission(name),
    status smallint default 1 CHECK(status > -1 and status < 2),
    created_at timestamp default now(),
    updated_at timestamp default now(),
	primary key(user_id, permission)
);
comment on table public.sys_user_permission is '用戶擁有哪些權限';
comment on column public.sys_user_permission.user_id is '員工編號';
comment on column public.sys_user_permission.permission is '權限名稱';
comment on column public.sys_user_permission.status is '關係狀態。0=禁用,1=啟用';
comment on column public.sys_user_permission.created_at is '創建時間';
comment on column public.sys_user_permission.updated_at is '最後更新時間，可以當作刪除的標準。';


/*
 * sys_usergroup 定義用戶組。這個非常重要，因為員工一定都會有部門，這樣會比較方便。
 * 用戶組可以視為一個特殊的用戶。
 * 因為有建 parent，所以可以用 CTE 遞迴(With Recursive)的方式取得用戶組的所有上級用戶組。
 */
create table if not exists public.sys_usergroup (
	name varchar(30) primary key not null,
	description varchar(100),
	parent varchar(30),
    created_at timestamp default now(),
    updated_at timestamp default now()
);
comment on table public.sys_usergroup is '設置用戶組，方便設置權限';
comment on column public.sys_usergroup.name is '用戶組名稱，方便辨識';
comment on column public.sys_usergroup.description is '用戶組說明';
comment on column public.sys_usergroup.parent is '父級用戶組，不填表示沒有';
comment on column public.sys_usergroup.created_at is '創建時間';
comment on column public.sys_usergroup.updated_at is '最後更新時間，可以當作刪除的標準。';


/*
 * sys_user_usergroup 定義用戶屬於哪些用戶組
 * 這裡採用的是記錄直接關聯用戶，因此搜尋的時候需要用遞迴的方式取得所有上級用戶組，會比較慢。
 */
create table if not exists public.sys_user_usergroup (
    user_id varchar(20) references public.sys_user(id),
    usergroup varchar(30) references public.sys_usergroup(name),
    status smallint default 1 CHECK(status > -1 and status < 2),
    created_at timestamp default now(),
    updated_at timestamp default now(),
    primary key(user_id, usergroup)
);
comment on table public.sys_user_usergroup is '用戶屬於哪些用戶組';
comment on column public.sys_user_usergroup.user_id is '員工編號';
comment on column public.sys_user_usergroup.usergroup is '用戶組名稱';
comment on column public.sys_user_usergroup.status is '關係狀態。0=禁用,1=啟用';
comment on column public.sys_user_usergroup.created_at is '創建時間';
comment on column public.sys_user_usergroup.updated_at is '最後更新時間，可以當作刪除的標準。';


/*
 * sys_usergroup_role 定義用戶組具有哪些角色，並透過 status 控制用戶組是否能使用該角色。
 * 針對用戶組新增角色可以大幅度降低資料量，因為用戶組的數量遠遠小於用戶的數量。
 */
-- 資料表
create table if not exists public.sys_usergroup_role (
    usergroup varchar(30) references public.sys_usergroup(name),
    role varchar(30) references public.sys_role(role),
    status smallint default 1 CHECK(status > -1 and status < 2),
    created_at timestamp default now(),
    updated_at timestamp default now(),
    primary key(usergroup, role)
);
comment on table public.sys_usergroup_role is '用戶組擁有哪些角色';
comment on column public.sys_usergroup_role.usergroup is '用戶組名稱';
comment on column public.sys_usergroup_role.role is '角色標籤';
comment on column public.sys_usergroup_role.status is '關係狀態。0=禁用,1=啟用';
comment on column public.sys_usergroup_role.created_at is '創建時間';
comment on column public.sys_usergroup_role.updated_at is '最後更新時間，可以當作刪除的標準。';


/* sys_usergroup_permission 定義用戶具有哪些權限
   這個具有第二高權限，主要是解決用戶組內部共享的資料夾、相簿或檔案。 */
create table if not exists public.sys_usergroup_permission (
	usergroup varchar(30) references public.sys_usergroup(name),
	permission varchar(30) references public.sys_permission(name),
    status smallint default 1 CHECK(status > -1 and status < 2),
    created_at timestamp default now(),
    updated_at timestamp default now(),
	primary key(usergroup, permission)
);
comment on table public.sys_usergroup_permission is '用戶組擁有哪些權限';
comment on column public.sys_usergroup_permission.usergroup is '用戶組';
comment on column public.sys_usergroup_permission.permission is '權限名稱';
comment on column public.sys_usergroup_permission.status is '關係狀態。0=禁用,1=啟用';
comment on column public.sys_usergroup_permission.created_at is '創建時間';
comment on column public.sys_usergroup_permission.updated_at is '最後更新時間，可以當作刪除的標準。';



--##########################################
-- 資料新增
--##########################################
--#########
-- 預設資料
-- 使用 transaction 來確保資料一致性
--#########
insert into public.sys_permission(name, description, operation) values
('tag-admin-G', '能否賦予管理員權限給他人的標籤', 'grant')
ON CONFLICT (name) DO NOTHING;

insert into public.sys_role(role, name, description) values
('root', '超級管理員', '擁有所有管理權限，且能夠賦予別人管理員職位'),
('admin', '管理員', '擁有所有管理權限，但無法賦予別人管理員職位'),
('employee', '普通用戶', '只能觀看自己拍攝的照片或者所屬部門的照片以及基礎功能。')
ON CONFLICT (role) DO NOTHING;

insert into public.sys_role_permission(role, permission) values
('root', 'tag-admin-G')
on conflict (role, permission) do nothing;

insert into public.sys_user(id, name, dept1, dept2, dept3, email) values
('00000000', '最高權限擁有人', 'super', 'test', 'abc', 'maxwell5566@yahoo.com.tw')
ON CONFLICT (id) DO NOTHING;

insert into public.sys_user_role(user_id, role) values
('00000000', 'root')
ON CONFLICT (user_id, role) DO NOTHING;


--#########
-- 測試資料
-- 可以測試 user->perm,usergroup->perm,role->perm
--#########
insert into public.sys_permission(name, description, operation) values
('test-super/test/abc-R', '測試權限1', 'read'),
('test-super/test-R', '測試權限2', 'read'),
('test-super-R', '測試權限3', 'read'),
('test-super1-R', '測試權限4', 'read'),
('test-super2-R', '測試權限5', 'read'),
('test-super3-R', '測試權限6', 'read')
ON CONFLICT (name) DO NOTHING;

insert into public.sys_role(role, name, description) values
('test-employee1', '測試角色1', '測試用角色1'),
('test-employee2', '測試角色2', '測試用角色2'),
('test-employee3', '測試角色3', '測試用角色3')
ON CONFLICT (role) DO NOTHING;

insert into public.sys_role_permission(role, permission) values
('test-employee1', 'test-super1-R'),
('test-employee2', 'test-super2-R'),
('test-employee3', 'test-super3-R')
ON CONFLICT (role, permission) DO NOTHING;

insert into public.sys_usergroup (name, description, parent) values
('super/test/abc', '測試用用戶組0', 'super/test'),
('super/test', '測試用用戶組1', 'super'),
('super', '測試用用戶組2', NULL)
ON CONFLICT (name) DO NOTHING;

insert into public.sys_usergroup_permission(usergroup, permission) values
('super/test/abc', 'test-super/test/abc-R'),
('super/test', 'test-super/test-R'),
('super', 'test-super-R')
ON CONFLICT (usergroup, permission) DO NOTHING;

insert into public.sys_usergroup_role (usergroup, role) values
('super/test/abc', 'test-employee3'),
('super/test', 'test-employee2'),
('super', 'test-employee1')
ON CONFLICT (usergroup, role) DO NOTHING;

insert into public.sys_user(id, name, dept1, dept2, dept3, email) values
('admin0', '測試用管理員', 'super', 'test', '', 'maxwell5566@yahoo.com.tw'),
('test0', '一級部門測試員', 'super', '', '', 'maxwell5566@yahoo.com.tw'),
('test1', '二級部門測試員', 'super', 'test', '', 'maxwell5566@yahoo.com.tw'),
('test2', '三級部門測試員', 'super', 'test', 'abc', 'maxwell5566@yahoo.com.tw')
ON CONFLICT (id) DO NOTHING;

insert into public.sys_user_usergroup (user_id, usergroup) values
('admin0', 'super/test'),
('test0', 'super'),
('test1', 'super/test'),
('test2', 'super/test/abc')
ON CONFLICT (user_id, usergroup) DO NOTHING;

insert into public.sys_user_role(user_id, role) values
('admin0', 'admin'),
('admin0', 'test-employee2'),
('test0', 'test-employee2'),
('test1', 'test-employee2'),
('test2', 'test-employee2'),
('test0', 'test-employee3'),
('test1', 'test-employee3'),
('test2', 'test-employee3')
ON CONFLICT (user_id, role) DO NOTHING;

insert into public.sys_user_permission(user_id, permission) values
('test0', 'test-super1-R'),
('test1', 'test-super2-R'),
('test2', 'test-super3-R')
ON CONFLICT (user_id, permission) DO NOTHING;