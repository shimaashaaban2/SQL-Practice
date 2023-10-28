use ITI

--1 --Create a scalar function that takes date and returns Month name of that date.
create function getMonth (@d date)
returns varchar(20)
    begin
	    declare @month varchar(20)
		     select @month = month(@d)
		return @month
	end

select dbo.getMonth('1/18/2023');

---------------------------------------------------------------------

--2 --Create a multi-statements table-valued function 
--    that takes 2 integers and returns the values between them.
alter function getBetween(@first int , @second int)
returns @t table
            (
			nums int
			)
as         
          begin
		       declare @x int=@first
			   while @x<@second-1
	              begin
	               	set @x+=1
		        	insert into @t
					select @x
	              end
			 return
		  end

select * from getBetween(1,10);

-------------------------------------------------------------

--3 --Create inline function 
--    that takes Student No and returns Department Name with Student full name.
create function getData(@st_num int)
returns table
as 
   return
        (
		select [dbo].[Department].Dept_Name , [dbo].[Student].St_Fname+' '+[dbo].[Student].St_Lname as [Full Name]
		from Department , Student
		where Department.Dept_Id=SC.Student.Dept_Id
		and Student.St_Id=@st_num
		)


select * from getData(10);

------------------------------------------------------------

--4 --Create a scalar function that takes Student ID and returns a message to user 
--  A-If first name and Last name are null then display 'First name & last name are null'
--  B-If First name is null then display 'first name is null'
--  C-If Last name is null then display 'last name is null'
--  D-Else display 'First name & last name are not null'
alter function getMessage (@stud_id int)
returns varchar(50)
                 begin
				 declare @msg varchar(50)
				 if (select Student.St_Fname from Student where Student.St_Id=@stud_id) is null
				 and (select Student.St_Lname from Student where Student.St_Id=@stud_id) is null
				   begin
				      select @msg='First name & last name are null'
				   end
		        else if (select Student.St_Fname from Student where Student.St_Id=@stud_id) is null
				   begin
				      select @msg='first name is null'
				   end
				else if (select Student.St_Lname from Student where Student.St_Id=@stud_id) is null
				   begin
				      select @msg='last name is null'
				   end
				else
				   begin
				      select @msg='First name & last name are not null'
				   end

				   return @msg
				 end

select dbo.getMessage(13);

--------------------------------------------------------------------

--5 --Create inline function that takes integer 
--    which represents manager ID and displays department name, Manager Name and hiring date 
alter function represent(@mngr_num int)
returns table
as 
   return
        (
		select Department.Dept_Name , Instructor.Ins_Name as [Manager Name] , Department.Manager_hiredate
		from Department , Instructor
		where Instructor.Ins_Id=Department.Dept_Manager
		and Department.Dept_Id=@mngr_num
		)

select * from represent(10);

--------------------------------------------------------------

--6 --Create multi-statements table-valued function that takes a string
--   If string='first name' returns student first name
--   If string='last name' returns student last name 
--   If string='full name' returns Full Name from student table 
--   Note: Use “ISNULL” function
create function getStudentData(@str Varchar(50))
returns @t table
               (
			   st_name varchar(50)
			   )
as 
        begin
		     if @str='first name'
			     begin
			       insert into @t
			       select isnull(st_fname,'no name') from Student
		         end
			else if @str='last name'
			     begin
			       insert into @t
			       select isnull(St_Lname,'no name') from Student
		         end
			else if @str='full name'
			     begin
			       insert into @t
			       select isnull(St_Fname+' '+St_Lname,'no name') as [full name] from Student
		         end
		   return
		end

select * from getStudentData('full name');

-----------------------------------------------------------------

--7 --Write a query that returns the Student No and Student first name without the last char
select Student.St_Id , SUBSTRING(Student.St_Fname,1,len(Student.St_Fname)-1)
from Student

-----------------------------------------------------------------

--8 --Wirte query to delete all grades for the students Located in SD Department
delete Stud_Course
from Stud_Course , Student ,Department
where Department.Dept_Id=Student.Dept_Id
and Student.St_Id=Stud_Course.St_Id
and Department.Dept_Name='SD'

------------------------------------------------------------------

--9 --Using Merge statement between the following two tables [User ID, Transaction Amount]
create table LastT
(
 id int,
 MyValue int
)

create table DailyT
(
 did int,
 Val int
)
Merge into LastT as T
using DailyT as S
on T.id=S.did
when matched then
	update 
		Set T.MyValue=S.Val
when not matched then
	insert 
	values(S.did,S.Val);

----------------------------------------------------------------------------

--10  --Try to Create Login Named(ITIStud) who
--    can access Only student and Course tablesfrom ITI DB 
--    then allow him to select and insert data into tables and deny Delete and update
create schema SC 

alter schema SC transfer Student
alter schema SC transfer Course
