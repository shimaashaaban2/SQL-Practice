use Company_SD

--1
select * from [dbo].[Employee];

--2
select Fname,Lname,Salary,Dno from [dbo].[Employee];

--3
select pname,plocation,dnum from [dbo].[Project];

--4
select fname+' '+lname+' '+convert(varchar(50),0.1*salary*12) as [ANNUAL COMM] 
from [dbo].[Employee];

--5
select fname 
from [dbo].[Employee]
where Salary > 1000;

--6
select fname 
from [dbo].[Employee]
where Salary*12 > 10000;

--7
select fname,Salary
from [dbo].[Employee]
where sex='female';

--8
select dnum ,dname
from [dbo].[Departments]
where MGRSSN=968574;

--9
select pnumber ,pname,plocation
from [dbo].[Project]
where dnum=10;