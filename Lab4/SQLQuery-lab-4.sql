use Company_SD

--1
select D.Dependent_name, D.Sex 
from Dependent D 
where D.Sex='F'
and D.ESSN in (select Employee.SSN from Employee where Employee.Sex='F')
Union
select D.Dependent_name, D.Sex 
from Dependent D , Employee E
where E.SSN=D.ESSN 
and D.Sex='M'
and E.Sex ='M';

--================================

--1 another way
select D.Dependent_name, D.Sex 
from Dependent D , Employee E
where E.SSN=D.ESSN 
and D.Sex='F'
and E.Sex ='F'
Union
select D.Dependent_name, D.Sex 
from Dependent D , Employee E
where E.SSN=D.ESSN 
and D.Sex='M'
and E.Sex ='M';

--------------------------------------------------

--2
select project.Pname,sum(Works_for.Hours)
from Project,Works_for
where Project.Pnumber=Works_for.Pno
group by Project.Pname;

-------------------------------------------------

--3
select Departments.*
from Departments 
where Departments.Dnum =
(select Employee.Dno -- 2-select the dept that has the min employee ssn
from Employee 
where Employee.SSN=
(select min(Employee.SSN) -- 1-select min employee ssn
from Employee
));

------------------------------------

--4
select Departments.Dname,min(Employee.Salary),max(Employee.Salary),avg(Employee.Salary)
from Departments , Employee
where Departments.Dnum=Employee.Dno
group by Departments.Dname;

-------------------------------------

--5
select Employee.Fname+' '+Employee.Lname as [full name of manager]
from Employee ,Departments ,Dependent
where Employee.SSN=Departments.MGRSSN -- select all employee who manages dept
and Employee.SSN not in
(select Employee.SSN -- select all employee not have dependents
from Employee,Dependent
where Employee.SSN=Dependent.ESSN);

--------------------------------------

--6--
select Departments.Dnum,Departments.Dname ,count(Employee.SSN)
from Departments ,Employee
where Departments.Dnum=Employee.Dno
group by Departments.Dname,Departments.Dnum
having (avg(Employee.Salary))<(select avg(Employee.Salary) from Employee);


----sub1 => to select avg salary for each dept
select avg(Employee.Salary),Departments.Dname
from Employee,Departments
where Departments.Dnum=Employee.Dno
group by Departments.Dname

----sub2 => to select avg salary for all employee
select avg(Employee.Salary)
from Employee

-----------------------------------------

--7--
select Employee.Fname,Project.Pname,Project.Dnum
from Employee , Project ,Works_for 
where Employee.SSN=Works_for.ESSn
and Project.Pnumber=Works_for.Pno
order by Project.Dnum,Employee.Lname,Employee.Fname



----------------------------------------

--8
select
(select max(Employee.Salary) from Employee) maxsalary_1,
(select max(Employee.Salary) from Employee
  where Employee.Salary != (select max(Employee.Salary) from Employee )) as maxsalary_2

------------------------------------------

--9
select Employee.Fname+' '+Employee.Lname as [full name]
from Employee , Dependent
where Employee.SSN=Dependent.ESSN
and Employee.Fname+' '+Employee.Lname like '%[in(select Dependent.Dependent_name
from Dependent)]%'

--sub1 => select dependent names
select Dependent.Dependent_name
from Dependent

-------------------------------

--10
select Employee.SSN , Employee.Fname
from Employee 
where exists
(select Employee.SSN
from employee , Dependent
where Employee.SSN=Dependent.ESSN)


--------------------------------

--11
insert into Departments(Dname , Dnum , MGRSSN ,[MGRStart Date]) 
values ('DEPT IT',100,112233,'1-11-2006');

---------------------------------

--12
--her record to be manager of dept 100
update Departments
set MGRSSN=968574
where Dnum=100

--my record
insert into Employee (SSN,Fname,Lname)values(102672,'ahmed','gaber');

--update my record to be manager of dept 20
update Departments
set MGRSSN=102672
where Dnum=20

-- update the employee to make me supervisor of him
update Employee
set Superssn=102672
where SSN=102660

---------------------------

--13--

--make kamel not the manager of any depts 
update Departments
set MGRSSN = Null
where MGRSSN=223344

--delete the dependent of kamel
delete from Dependent
where ESSN=223344

--make kamel not the supervisor of any other employee
update Employee
set Superssn=Null
where Superssn=223344

-- make kamel not work in any project
update Works_for
set ESSn=102672 
where ESSn=223344

--delete the kamel data
delete from Employee
where SSN=223344

---------------------------

--14
update Employee
set Salary +=0.3*Salary
where Employee.SSN in (
         select Employee.SSN -- select employees ssn who work in Al Rabwah project 
         from Project , Employee , Works_for
         where Employee.SSN=Works_for.ESSn
         and Project.Pnumber=Works_for.Pno
         and Project.Pname='Al Rabwah'
);