@/home/eintr/Projects/DatabaseSystem/oracle/sql_file/01_del_data.sql;
@/home/eintr/Projects/DatabaseSystem/oracle/sql_file/02_hr_cre.sql;
@/home/eintr/Projects/DatabaseSystem/oracle/sql_file/03_hr_popul.sql;
SELECT
    EMPLOYEE_ID ,
    FIRST_NAME ,
    LAST_NAME ,
    EMAIL ,
    PHONE_NUMBER ,
    HIRE_DATE ,
    JOB_ID ,
    SALARY ,
    COMMISSION_PCT ,
    MANAGER_ID ,
    DEPARTMENT_ID
FROM employees;

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


-- where 过滤
select last_name, hire_date
from employees
where to_char(hire_date, 'yyyy-mm-dd') = '1994-06-07';

-- 比较函数
-- between and [] 闭区间
select last_name, hire_date, salary
from employees
where salary between 4000 and 7000;

-- in 
select last_name, department_id, salary
from employees
where department_id in (70, 80, 90);
--where department_id = 70 or department_id = 80 or department_id = 90;

-- like 模糊查询
-- 员工名字中含有字符a的员工
select last_name, department_id, salary
from employees
--where last_name like '%a%';
--where last_name like '_a%';
--where last_name like '__a%';
where last_name like '%\_%' escape '\';

-- ORDER BY 子句
-- desc 从大到小
-- asc  从小到大
select last_name, department_id, salary
from employees
where department_id = 80
--order by salary desc;
--order by salary asc;
order by salary desc, last_name asc;

-- 1. 查询工资大于12000的员工姓名和工资
select last_name, salary
from employees
where salary > 12000;

-- 2. 查询员工号为176的员工的姓名和部门号
select last_name, department_id
from employees
where employee_id = 176;

-- 3. 选择工资不在5000到12000的姓名和工资
select last_name, salary
from employees
where salary not between 5000 and 12000;

--4. 寻在雇用时间在1998-02-01到1998-05-01之间的员工姓名，job_id和雇用时间
select last_name, job_id
from employees
where to_char(hire_date, 'yyyy-mm-dd')
between '1998-02-01' and '1998-05-01';

--5.选择在20或50号部门工作的员工姓名和部门号
select last_name, department_id
from employees
where department_id  in (20, 50);

--6.选择在1994年雇用的员工的姓名和雇用时间
select last_name, hire_date
from employees
where to_char(hire_date, 'yyyy') = '1994';

--7.选择公司中没有管理者的员工姓名及job_id
select last_name, job_id
from employees
where manager_id is null;

--8.选择公司中有奖金的员工姓名，工资和奖金级别
select last_name, salary, commission_pct
from employees
where commission_pct is not null;

--9.选择员工姓名的第三个字母是a的员工姓名
select last_name
from employees
where last_name like '__a%';

--10.选择姓名中有字母a和e的员工姓名
select last_name
from employees
where 
    last_name like '%a%e%' 
    or 
    last_name like '%e%a%'; 

-- 单行函数
    -- 字符
select
lower('ATGUIGUJAVA'), 
upper('AtGuiGu Java'),
initcap('AtGuiGu java')
from dual;

select *
from employees
where lower(last_name) = 'king';

select 
concat('hello', 'world'), 
substr('helloworld', 2, 4), -- 从1开始
length('helloworld')
from dual;

select instr('helloworld', 'l') from dual;

select
employee_id, last_name,
lpad(salary, 10, '*'), rpad(salary, 10, ' ')
from employees;

select trim('l' from 'lhelloworldl') from dual; -- 去除首尾的

select replace('helloworld', 'l', 'n')from dual; -- 替换所有的

    -- 数值
select round(435.45,2), round(435.45), round(435.45,-1)
from dual;

select trunc(123.456)from dual;

select mod(1100, 300)from dual;
    
    -- 日期
select employee_id, last_name, round(sysdate - hire_date)
from employees; -- 日期之间不允许做加法 可以做减法 表示相差的天数

select employee_id, last_name, 
round(months_between(sysdate, hire_date))
from employees;

select 
ADD_MONTHS(sysdate, 2),
ADD_MONTHS(sysdate, 3), 
NEXT_DAY(sysdate, 'sunday')
from dual;

-- 来公司的员工中，hire_date是每个月倒数第二天来公司的有哪些
select last_name, hire_date
from employees
where hire_date = last_day(hire_date) - 1;

    -- 转换
select employee_id, hire_date
from employees
where to_char(hire_date, 'yyyy"年"mm"月"dd"日"') = '1994年06月07日';

select to_char(123456.789, '$000,000,999.99') from dual;

select to_number('￥001,234,567.89', 'L000,000,999.99')
from dual;

    -- 通用
select employee_id, last_name, salary * 12 * (1 + commission_pct)
from employees;

-- nvl2 相当于三元表达式
select
last_name,
commission_pct,
nvl2(commission_pct, commission_pct + 0.015, 0.01)
from employees;

-- 条件表达式 
-- case exp when a then A
--          when b then B
--          when c then C end
select employee_id, last_name, department_id,
    case department_id when 10 then salary * 1.1
                        when 20 then salary *1.2
                        else salary * 1.3  end new_sal
from employees
where department_id in (10, 20, 30);

-- 条件语句 
-- decode(exp, a, A,
--              b, B,
--              c, C)
select employee_id, last_name, department_id, 
decode(department_id, 10, salary * 1.1,
                      20, salary * 1.2,
                      salary * 1.3) new_sal
from employees
where department_id in (10, 20, 30);

--1.显示系统时间(注：日期+时间)
select to_char(sysdate, 'yyyy-mm-dd hh:mm:ss') from dual;

--2.查询员工号，姓名，工资，以及工资提高百分之20%后的结果（new salary）
select employee_id, last_name, salary, salary * 1.2 as mew_sal
from employees;

--3.将员工的姓名按首字母排序，并写出姓名的长度（length）
select last_name, length(last_name) 
from employees
order by last_name asc;

--4.查询各员工的姓名，并显示出各员工在公司工作的月份数（worked_month）。
select 
last_name, 
round(
    months_between(sysdate, hire_date),
    1) worked_month 
from employees;

--5.查询员工的姓名，以及在公司工作的月份数（worked_month），并按月份数降序排列
select last_name, round(
    months_between(sysdate, hire_date), 1) worked_month
from employees
order by worked_month desc;

--6.做一个查询，产生下面的结果
--<last_name> earns <salary> monthly but wants <salary*3>
--Dream Salary
--King earns $24000 monthly but wants $72000
select 
last_name || ' earns ' || to_char(salary, '$999999') ||
' monthly but wants ' || to_char(salary * 3, '$999999') "Dream Salary"
from employees;


--7.使用decode函数，按照下面的条件：
--job                  grade
--AD_PRES            A
--ST_MAN             B
--IT_PROG             C
--SA_REP              D
--ST_CLERK           E
--产生下面的结果
--Last_name	Job_id	Grade
--king	AD_PRES	A
select 
last_name "Last_name",
job_id "Job_id",
decode(job_id, 'AD_PRES', 'A',
                'ST_MAN', 'B',
                'IT_PROG', 'C',
                'SA_REP', 'D',
                'ST_CLERK', 'E') "Grade"
from employees;

-- 8.将第7题的查询用case函数再写一遍。
select 
last_name "Last_name",
job_id "Job_id",
case job_id when 'AD_PRES 'then 'A'
            when 'ST_MAN' then 'B'
            when 'IT_PROG' then 'C'
            when 'SA_REP' then 'D'
            when 'ST_CLERK' then 'E' end  "Grade"
from employees;


-- 多表查询
select 
employees.employee_id, employees.department_id, departments.department_name
from employees, departments
where employees.department_id = departments.department_id;

select 
employee_id, d.department_id,department_name
from employees e, departments d
where e.department_id = d.department_id;

-- 三张表连接就需要至少2个链接条件
select
employee_id, d.department_id, department_name, l.city
from employees e, departments d, locations l
where e.department_id = d.department_id and d.location_id = l.location_id;

-- 左外连接
select 
employee_id, d.department_id,department_name
from employees e, departments d
where e.department_id = d.department_id(+);

-- 右外连接
select
employee_id, d.department_id, department_name
from employees e, departments d
where e.department_id(+) = d.department_id;

-- 使用 on 关键字
select
employee_id, d.department_id, department_name
from employees e join departments d
on e.department_id = d.department_id
join locations l
on d.location_id = l.location_id;

-- 左外连接
select
employee_id, e.department_id, department_name
from employees e left join departments d
on e.department_id = d.department_id;

-- 右外连接
select
employee_id, e.department_id, department_name
from employees e right join departments d
on e.department_id = d.department_id;

-- 满外连接
select
employee_id, e.department_id, department_name
from employees e full join departments d
on e.department_id = d.department_id;

-- 自连接
select e.last_name e_name, m.last_name m_name, m.salary, m.email 
from employees e, employees m
where e.manager_id = m.employee_id 
        and lower(e.last_name) = 'chen';


--1.显示所有员工的姓名，部门号和部门名称。
select last_name, e.department_id, d.department_name
from employees e, departments d
where e.department_id = d.department_id(+);

--方法二：
select last_name, e.department_id, department_name
from employees e left join departments d
on e.department_id = d.department_id;

--2.查询90号部门员工的job_id和90号部门的location_id
select DISTINCT
job_id, location_id
from employees e left join departments d
on e.department_id = d.department_id
where d.department_id = 90;

--3.选择所有有奖金的员工的
--last_name , department_name , location_id , city
select
last_name, department_name, l.location_id, city
from employees e join departments d
on e.department_id = d.department_id
join locations l
on d.location_id = l.location_id
where e.commission_pct is not null;

--4.选择city在Toronto工作的员工的
--last_name , job_id , department_id , department_name
select
last_name, job_id, d.department_id, department_name
from employees e join departments d
on e.department_id = d.department_id
join locations l
on d.location_id = l.location_id
where l.city = 'Toronto';
-- 第二种方法
select last_name , job_id , e.department_id , department_name
from employees e ,departments d,locations l
where e.department_id = d.department_id and l.city = 'Toronto' and d.location_id = l.location_id;

--5.选择指定员工的姓名，员工号，以及他的管理者的姓名和员工号，结果类似于下面的格式
--employees	Emp#	manager	Mgr#
--kochhar	101	king	100

select 
e.last_name "employees", e.employee_id "Emp#", m.last_name "manager", m.employee_id "Mgr#"
from employees e, employees m
where e.manager_id = m.employee_id;


-- 多行函数（分组函数）
-- 在 SELECT 列表中所有未包含在组函数中的列都应该包含在 GROUP BY 子句中

-- AVG 只能用于number类型的数据
select department_id, avg(salary)
from employees
where department_id in (40, 60, 80)
group by department_id;

select department_id, avg(salary)
from employees
group by department_id;

select department_id, job_id, avg(salary)
from employees
group by department_id, job_id;

-- COUNT 计算非空数据的统计值
select count(commission_pct)
from employees;

select 
avg(commission_pct), sum(commission_pct)/count(nvl(commission_pct, 1)),
sum(commission_pct)/count(107)
from employees;

-- MAX 只能放number类型的数据
select max(last_name), min(last_name), max(hire_date), min(hire_date)
from employees;
-- MIN 这能用于number类型的数据
select max(last_name), min(last_name), max(hire_date), min(hire_date)
from employees;
-- STDDEV
-- SUM

-- 不可以在WHERE子句中使用组函数
-- 可以在HAVING子句中使用组函数
-- 求出各部门中平均工资大于6000的部门，以及其平均工资
select department_id, avg(salary)
from employees
having avg(salary) > 6000 
group by department_id
order by department_id ;


-- Toronto 这个城市的员工的平均工资
select 'Toronto', avg(salary)
from employees e, departments d, locations l
where 
    e.department_id = d.department_id 
and
    d.location_id = l.location_id
and 
    lower(l.city) = 'toronto';

-- 各个城市的平均工资
select city, avg(salary)
from employees e, departments d, locations l
where e.department_id = d.department_id and d.location_id = l.location_id
group by city;

-- 查询平均工资高于8000的部门id和它的平均工资
select department_id, avg(salary)
from employees
having avg(salary) > 8000
group by department_id;

-- 查询平均工资高于6000的job_title有哪些
select job_title, avg(salary)
from employees e join jobs j
on e.job_id = j.job_id
having avg(salary) > 6000
group by job_title;

-- 测试
--1.组函数处理多行返回一行吗?
--是
--2.组函数不计算空值吗？
--是
--3.where子句可否使用组函数进行过滤?
--不可以，用having替代
--4.查询公司员工工资的最大值，最小值，平均值，总和
select max(salary), min(salary), avg(salary), sum(salary)
from employees;

--5.查询各job_id的员工工资的最大值，最小值，平均值，总和
select max(salary), min(salary), avg(salary), sum(salary)
from employees
group by job_id;

--6.选择具有各个job_id的员工人数
select job_id, count(employee_id)
from employees
group by job_id;

--7.查询员工最高工资和最低工资的差距（DIFFERENCE）
select max(salary) - min(salary) "DIFFERENCE"
from employees;

--8.查询各个管理者手下员工的最低工资，其中最低工资不能低于6000，没有管理者的员工不计算在内
select min(salary)
from employees
where manager_id is not null
having min(salary) >= 6000
group by manager_id;

--9.查询所有部门的名字，location_id，员工数量和工资平均值
select department_name, location_id, count(employee_id), avg(salary)
from employees e right join departments d
on e.department_id = d.department_id
group by department_name,location_id; 

--10.查询公司在1995-1998年之间，每年雇用的人数，结果类似下面的格式
--total	1995	1996	1997	1998
-- 20	  3	      4	      6	      7
-- 
select 
count(*) "total",
count(case to_char(hire_date, 'yyyy') when '1995' then 1 end) "1995",
count(case to_char(hire_date, 'yyyy') when '1996' then 1 end) "1996",
count(case to_char(hire_date, 'yyyy') when '1997' then 1 end) "1997",
count(case to_char(hire_date, 'yyyy') when '1998' then 1 end) "1998"
from employees
where to_char(hire_date, 'yyyy') in  ('1995', '1996', '1997', '1998');


select count(*) "total",
       count(decode(to_char(hire_date,'yyyy'),'1995',1,null)) "1995",
       count(decode(to_char(hire_date,'yyyy'),'1996',1,null)) "1996",
       count(decode(to_char(hire_date,'yyyy'),'1997',1,null)) "1997",
       count(decode(to_char(hire_date,'yyyy'),'1998',1,null)) "1998"
from employees
where to_char(hire_date,'yyyy') in ('1995','1996','1997','1998');




