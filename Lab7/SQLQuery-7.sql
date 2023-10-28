use ITI

--1 --Create a view that displays student full name,
--  course name if the student has a grade more than 50. 
create view VFullName
as
	select [SC].[Student].St_Fname+' '+[SC].[Student].St_Lname as [Full Name] ,[SC].[Course].Crs_Name 
	, [dbo].[Stud_Course].Grade
	from  [SC].[Student] ,  [SC].[Course] , [dbo].[Stud_Course]
	where [SC].[Student].St_Id=Stud_Course.St_Id
	and [SC].[Course].Crs_Id= Stud_Course.Crs_Id
	and [dbo].[Stud_Course].Grade>50;

select * from VFullName

-------------------------------------------------------------------------------------

-- 2--Create an Encrypted view that displays manager names and the topics they teach. 
alter view VMngr_Topic
with encryption
as
	select Instructor.Ins_Name , Topic.Top_Name
	from Instructor , Topic , Department , Ins_Course , SC.Course 
	where Instructor.Ins_Id=Department.Dept_Manager
	and Instructor.Ins_Id=Ins_Course.Ins_Id
	and sc.Course.Crs_Id=Ins_Course.Crs_Id
	and Topic.Top_Id=sc.Course.Top_Id

select * from VMngr_Topic

--------------------------------------------------------------------------------

--3 --Create a view 
--    that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department 
create view INS_DEPT
as
	select Instructor.Ins_Name , Department.Dept_Name
	from Instructor , Department
	where Department.Dept_Id=Instructor.Dept_Id
	and Department.Dept_Name in('SD','Java')

select * from INS_DEPT

----------------------------------------------------------------------------------

--4 --Create a view “V1” that displays student data for student who lives in Alex or Cairo. 
    --Note: Prevent the users to run the following query 
--    Update V1 set st_address=’tanta’
--    Where st_address=’alex’;
create View V1
as
	select sc.Student.*
	from sc.Student
	where sc.Student.St_Address in('Alex','Cairo')
	with check option

update V1
set St_Address='Tanta'
where St_Address='Alex'

---------------------------------------------------------------------------------

--5 --Create a view that will display the project name 
--   and the number of employees work on it
--   “Use Company DB”
use Company_SD

create view V2
as
    select count(Employee.SSN) as Count,Project.Pname
	from Employee,Project,Works_for
	where Project.Pnumber=Works_for.Pno
	and Employee.SSN=Works_for.ESSn
	group by Project.Pname

select * from V2

-------------------------------------------------------------------------

--6 --Create the following schema and transfer the following tables to it 
--    a.Company Schema 
--        i.Department table (Programmatically)
--        ii.Project table (by wizard)
--    b.Human Resource Schema
--        i.Employee table (Programmatically)
create schema CmpnyS;
alter schema CmpnyS transfer [dbo].[Departments]

create schema HR;
alter schema HR transfer [dbo].[Employee]

-------------------------------------------------------------------------

--7 --Create index on column (manager_Hiredate) that allow u 
--    to cluster the data in table Department. 
--    What will happen?  - Use ITI DB
use ITI

create clustered index i1
on Department(Department.Manager_hiredate);

--8 --Create index that allow u to enter unique ages in student table.
--    What will happen?  - Use ITI DB
use ITI
create unique index i2
on [SC].[Student](sc.student.st_age);

--9 --Create a cursor for Employee table that increases Employee salary by 10% if Salary <3000 
--   and increases it by 20% if Salary >=3000. Use company DB
use Company_SD

declare c1 Cursor
for select Employee.Salary
	from Employee
for update
declare @sal int
open c1
fetch c1 into @sal
while @@fetch_status=0
	begin
		if @sal<3000
			update Employee
				set salary=@sal*1.1
			where current of c1
		else
			update Employee
				set Salary=@sal*1.2
			where current of c1
		fetch c1 into @sal
	end
close c1
deallocate c1

-----------------------------------------------------------------------

-- 10 --Display Department name with its manager name using cursor. Use ITI DB
use ITI

Declare C1 Cursor
for select Department.Dept_Name,Instructor.Ins_Name
	from Department,Instructor
	where Instructor.Ins_Id=Department.Dept_Manager
for read only     
declare @Dept_Name varchar(20),@Manager varchar(20)
open C1
Fetch C1 into @Dept_Name,@Manager
while @@FETCH_STATUS=0
	begin
		select @Dept_Name,@Manager
		Fetch C1 into @Dept_Name,@Manager
	end
close C1
Deallocate C1

----------------------------------------------------------------------

--11 --Try to display all instructor names in one cell separated by comma
--     Using Cursor . Use ITI DB
use ITI
declare c1 cursor
for select distinct Instructor.Ins_Name
	from Instructor
	where Instructor.Ins_Name is not null
for read only

declare @INS_name varchar(20),@all_INS_names varchar(300)=''
open c1
fetch c1 into @INS_name
while @@FETCH_STATUS=0
	begin
		set @all_INS_names=concat(@all_INS_names,',',@INS_name)
		fetch c1 into @name   --Next Row 
	end
select @all_INS_names
close c1
deallocate C1

---------------------------------------------------------------------------

--12 --Try to generate script from DB ITI that describes all tables and views in this DB
