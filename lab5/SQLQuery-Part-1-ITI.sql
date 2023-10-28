use ITI

--1 --Retrieve number of students who have a value in their age. 
select count([St_Id]) 
from [dbo].[Student]
 ;

--2 --Get all instructors Names without repetition
select distinct [Ins_Name]
from [dbo].[Instructor]

--3 --Display student with the following Format (use isNull function)
select [St_Id] , ISNULL([St_Fname],' ') + ' '+ ISNULL([St_Lname],' ') as [Full Name] , [Dept_Name]
from [dbo].[Student] , [dbo].[Department]
where Department.Dept_Id=Student.Dept_Id;

--4 --Display instructor Name and Department Name 
--    Note: display all the instructors if they are attached to a department or not
select Instructor.Ins_Name,Department.Dept_Name
from Instructor left outer join Department
on Instructor.Ins_Id=Department.Dept_Id;

--5 --Display student full name and the name of the course he is taking
--    For only courses which have a grade  
select ISNULL(Student.St_Fname,' ') + ' '+ ISNULL(Student.St_Lname,' ') as [Full Name] , Course.Crs_Name
from Student , Course ,Stud_Course
where Student.St_Id=Stud_Course.St_Id
and Course.Crs_Id=Stud_Course.Crs_Id
and Stud_Course.Grade is not null;


--6	--Display number of courses for each topic name ---------
select COUNT(Course.Crs_Id) ,Topic.Top_Name
from Course , Topic
where Topic.Top_Id=Course.Crs_Id
group by Topic.Top_Name;

--7 --Display max and min salary for instructors
select max(Instructor.Salary) as [Max Salary] , min(Instructor.Salary) as [Min Salary]
from Instructor;

--8 --Display instructors who have salaries less than the average salary of all instructors.
select Instructor.Ins_Name
from Instructor
where Instructor.Salary<(select avg(Instructor.Salary) from Instructor);

---xxxxxxxxxxxxxxxxxx
--9 --Display the Department name that contains the instructor who receives the minimum salary.
select Department.Dept_Name
from Department , Instructor
where Instructor.Ins_Id=Department.Dept_Id-----xxxxxxxxxxxxxxx
and
Instructor.Ins_Id=(select Instructor.Ins_Id -- select Instructor.Ins_Id with min salary
from Instructor 
where Instructor.Salary = (select min(Instructor.Salary) from Instructor))

--sup1 --to get instructor with min salary
--select Instructor.Ins_Id
--from Instructor 
--where Instructor.Salary = (select min(Instructor.Salary) from Instructor)

--10 --Select max two salaries in instructor table. 
select top(2) Instructor.Salary
from Instructor
order by Instructor.Salary desc;

--11 --Select instructor name and his salary but 
--     if there is no salary display instructor bonus keyword. “use coalesce Function”
select Instructor.Ins_Name , coalesce(Instructor.Salary,'bonus')
from Instructor;

--12 --Select Average Salary for instructors
select AVG(Instructor.Salary)
from Instructor


--13 --Select Student first name and the data of his supervisor 
select x.St_Fname as [Student Name], y.*
from Student x ,Student y
where x.St_Id=y.St_super;


--14 --Write a query to select the highest two salaries
--     in Each Department for instructors who have salaries. “using one of Ranking Functions”
select Instructor.Salary
from (select Instructor.* ,ROW_NUMBER()over(partition by Department.Id order by Instructor.Salary desc) as RN
from Instructor) as x ,Instructor
where RN<=2;

----
--select Instructor.Salary
--from (select Instructor.* ,ROW_NUMBER()over(partition by Department.Dept_Name order by Instructor.Salary desc) as RN
--from Instructor , Department where Instructor.Ins_Id=Department.Dept_Manager) as x ,Instructor
--where RN<=2;


--15 --Write a query to select a random  student from each department.
--     “using one of Ranking Functions”
select * from
(select Student.* ,ROW_NUMBER()over(partition by Student.Dept_Id order by newid() desc) as RN
from Student ) as x 
where RN=1;