use Company_SD

--1
select [Dnum],[Dname],[Fname] as [manager]
from [dbo].[Departments] ,[dbo].[Employee]
where [dbo].[Employee].SSN=[dbo].[Departments].MGRSSN;

--2
select [Dname] ,[Pname]
from Departments , Project
where Departments.Dnum=Project.Dnum;

--3
select Dependent.* , Employee.Fname
from Dependent , Employee
where Employee.SSN=Dependent.ESSN;

--4
select Project.Pname , Project.Pnumber , Project.Plocation
from Project
where Project.City in('Cairo' , 'Alex');

--5
select Project.* 
from Project
where Project.Pname like 'a%';

--6
select Employee.Fname
from Employee , Departments
where Departments.Dnum=30 and Employee.Salary between 1000 and 2000;

--7--
select Employee.Fname+' '+Employee.Lname as[full name]
from Employee , Project , Works_for
where Employee.SSN=Works_for.ESSn and Project.Pnumber=Works_for.Pno 
and Employee.Dno=10 and Works_for.Hours>=10 and Project.Pname='AL Rabwah';

--8--
select x.Fname+' '+x.Lname as [full name]
from Employee x , Employee y
where y.Fname ='Kamel' and y.Lname='Mohamed' and y.SSN = x.Superssn;

--9
select Employee.Fname , Project.Pname
from Employee inner join  Works_for
on Employee.SSN=Works_for.ESSn 
inner join Project
on Project.Pnumber=Works_for.Pno
order by Project.Pname;

--10
select Project.Pnumber , Departments.Dname , Employee.Lname , Employee.Address , Employee.Bdate
from Employee inner join Departments
on Employee.SSN=Departments.MGRSSN
inner join Project
on Departments.Dnum=Project.Dnum
and Project.City='Cairo';

--11
select Employee.* 
from Employee , Departments
where Employee.SSN=Departments.MGRSSN;

--12
select Employee.* , Dependent.*
from Employee left outer join Dependent
on Employee.SSN=Dependent.ESSN;

--13
insert into Employee(Dno,SSN,Superssn,Salary) values (30,102672,112233,3000);

--14
insert into Employee(Dno,SSN) values (30,102660);

--15--
update Employee
set Salary=1.2*Salary
where SSN=102660;
