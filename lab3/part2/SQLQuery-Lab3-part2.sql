use lab3part2

create table Instructor(
ID int primary key identity,
Salary int ,
Hiredate date default getdate(),
Address varchar(50),
Overtime int ,
BD date ,
Fname varchar(50),
Lname varchar(50),
NetSalary as(Salary+Overtime) persisted,
Age as (year(getdate())-year(BD)),

--constraints
constraint c1 check(address in('cairo','alex')),
--------------------------
constraint c2 unique(Overtime),
);

--default
create default def1 as 3000;
sp_bindefault def1,'Instructor.Salary'

--=================================================================

create table Course(
CID int primary key identity ,
Cname varchar(50),
Duration int,
);

--=================================================================

create table [Instructor_Course](
IID int not null,
CID int not null,

--constraints
constraint c20 foreign key (IID) references Instructor(ID)
on delete cascade on update cascade,
--------------------------
constraint c21 foreign key (CID) references Course(CID)
on delete cascade on update cascade,
--------------------------
constraint c22 primary key(IID,CID)
);

--=================================================================

create table Lab(
LID int primary key identity,
CID int ,
Location varchar(50),
Capacity int,

--constraints
constraint c31 foreign key (CID) references Course(CID)
on delete cascade on update cascade,
------------------------
constraint c32 check(Capacity < 20),
);