--##############
-- 清空舊有資料表
-- 由於部分資料表有使用外部鍵，因此統一在這裡定義。
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

drop table if exists public.knowledge_tag;
drop table if exists public.spell_knowledge;
drop table if exists public.tag;
drop table if exists public.knowledge;
drop table if exists public.spell;