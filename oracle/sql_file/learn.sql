@/home/eintr/Projects/DatabaseSystem/oracle/sql_file/01_del_data.sql;
@/home/eintr/Projects/DatabaseSystem/oracle/sql_file/02_hr_cre.sql;
@/home/eintr/Projects/DatabaseSystem/oracle/sql_file/03_hr_popul.sql;
SELECT
    * FROM
    employees;

-- DML 数据操作语言
-- DDL 数据定义语言
-- DCL 数据控制语言

desc employees;

select * from employees;

select
    employee_id, last_name, email
    from employees;

-- 算术计算 dual 一个伪表
select 8 * 4 from dual;
    
--- 日期函数
select sysdate ,sysdate + 1,sysdate - 1
from dual;

-- 空值不同于0,凡是空值参与运算的结果都是空(null)

-- oracle的别名
select employee_id id, last_name name, 12 * salary annual_salary
from employees;
-- 或者使用AS
select employee_id as id, last_name as name, 12 * salary as annual_salary
from employees;
-- 还可以强制大小写
select employee_id as "id", last_name as "name", 12 * salary as "annual_salary"
from employees;

-- || 表示字符串连接
select last_name || '''s job_id is ' ||job_id as details
from employees;


-- 去重
select distinct department_id
from employees;




    
    
    
    
    
