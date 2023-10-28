use ITI

--1 --Create a stored procedure 
--    without parameters to show the number of students per department name.[use ITI DB] s
alter Proc GetStdNums
as
	select COUNT(sc.Student.St_Id) as [Number of Students] , Department.Dept_Name
	from sc.Student , Department
	where SC.Student.Dept_Id=Department.Dept_Id
	group by Department.Dept_Name

GetStdNums

----------------------------------------------------------------------------

--2 --Create a stored procedure that will check for the # of employees in the project p1 
--    if they are more than 3 print message to the user “'The number of employees in the project p1 is 3 
--    or more'” if they are less display a message to the user
--    “'The following employees work for the project p1'” 
--    in addition to the first name and last name of each one. [Company DB] 

use Company_SD

Create Proc CheckEmp
as
  if(select count(HR.Employee.SSN) 
   from hr.Employee , Project , Works_for 
  where hr.Employee.SSN=Works_for.ESSn 
  and Project.Pnumber=Works_for.Pno
  and Project.Pname='AL Solimaniah') > 3
      begin
         select 'The number of employees in the project p1 is 3 or more';

	     select HR.Employee.Fname , HR.Employee.Lname
	     from hr.Employee , Project , Works_for 
	     where hr.Employee.SSN=Works_for.ESSn 
         and Project.Pnumber=Works_for.Pno
         and Project.Pname='AL Solimaniah';
      end
   else 
      begin
	     select 'The following employees work for the project p1';

		 select HR.Employee.Fname , HR.Employee.Lname
	     from hr.Employee , Project , Works_for 
	     where hr.Employee.SSN=Works_for.ESSn 
         and Project.Pnumber=Works_for.Pno
         and Project.Pname!='AL Solimaniah';
	  end
       
	

execute CheckEmp

---------------------------------------------------------------------------

--3 --Create a stored procedure that will be used 
--    in case there is an old employeehas left the project 
--    and a new one become instead of him.
--    The procedure should take 3 parameters (old Emp. number, 
--    new Emp.number and the project number) and it will be used to update works_on table.
--    [Company DB]

use Company_SD --try catch

create Proc CheckUpdate @OldEmpNum int , @NewEmpNum int , @ProjectNum int
as
    begin Try
	    update Works_for
	    set [dbo].[Works_for].ESSn=@NewEmpNum
	    where Works_for.Pno=@ProjectNum
	    AND [dbo].[Works_for].ESSn=@OldEmpNum 
	end Try
	begin Catch
	    select 'Not Allowed ESSN'
	end Catch
	

execute CheckUpdate 1 ,3 ,100

----------------------------------------------------------------------

--4 --
Create Table  Audit 
(
 ProjectNo  int,
 UserName  varchar(50),
 ModifiedDate  Date,
 Budget_Old int,
 Budget_New int
)
create trigger AddUpdates
on Project
instead of update
as
	if update(budget)
		begin
			declare @oldBudget int,@newBudget int , @projectNum int 
			select @oldBudget= budget from deleted
			select @newBudget= budget from inserted
			select @projectNum=Project.Pnumber from deleted
			insert into Audit
			values(@projectNum,suser_name(),getdate(),@oldBudget,@newBudget)
		end

update Project
set budget=1111
where budget=10000;

----------------------------------------------------------------------------------

--5 --Create a trigger to prevent anyone from inserting a new record 
--    in the Department table [ITI DB]
--    “Print a message for user to tell him that he can’t insert a new record in that table”
use ITI

create trigger PreventInsert
on [dbo].[Department]
instead of insert
as
	select 'Print a message for user to tell him that he can’t insert a new record in that table'


--------------------------------------------------------------------------------------

--6 --Create a trigger that prevents the insertion Process 
--    for Employee table in March [Company DB].

use Company_SD

create trigger PereventInMarch
on [HR].[Employee]
instead of insert
as
	if format(getdate(),'MMMM')='friday'
		select 'not allowed'
	else -- insert based on select
	    begin
	     insert into [HR].[Employee] select * from inserted;
		end


---------------------------------------------------------------------

--7 --Create a trigger on student table after insert to add Row in 
--    Student Audit table (Server User Name , Date, Note) 
--    where note will be “[username] Insert New Row with Key=[Key Value] in table [table name]”
use ITI

alter trigger sc.t7 
on [SC].[Student]
after insert
as
   declare @Key int; --convert
   declare @TableName varchar(20);

   select @Key= St_Id from inserted ;
   insert into StudentAudit (ServerUserNmae,Datee,Note)
   values(SUSER_NAME(),
   getdate(),
   SUSER_NAME()+' Insert New Row with Key='+convert(varchar(10),@Key)+' in table StudentAudit');
	
insert into [SC].[Student](St_Fname,St_Id) values('ahmed',101);
--8 --Create a trigger on student table instead of delete to add Row 
--    in Student Audit table (Server User Name, Date, Note)
--    where note will be“ try to delete Row with Key=[Key Value]”
use ITI

create trigger t8 --
on [SC].[Student]
instead of delete
as
   declare @Key int;
   select @Key=St_Id from deleted;
   insert into StudentAudit (ServerUserNmae,Datee,Note)
   values(SUSER_NAME(),getdate(),'try to delete Row with Key= '+convert(varchar(10),@Key));