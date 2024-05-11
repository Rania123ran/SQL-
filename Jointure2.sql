create database TP7
go
use tp7
go
 create table Employee
(
            EmployeeId    int Primary key identity(1,1),
            FirstName      varchar(50),
            LastName       varchar(50),
            Salary             decimal(18,2),
            JoiningDate    date,
            Department   varchar(50)
			)
			go
 Insert Into Employee values ('Vikas', 'Verma', 40000, '2016-05-21', 'IT'),
							 ('Anil', 'Kumar', 800000, '2015-10-31', 'Insurance'),
							 ('Vishal', 'Sonkar', 700000, '2015-12-09', 'Banking'),
							 ('Abhishek', 'Singh', 44000, '2015-02-19', 'Insurance'),
							 ('Durgesh', 'Tiwari', 33000, '2015-12-07', 'Insurance'),
							 ('Ravi', 'Kumar', 55000, '2016-03-31', 'Services'),
							 ('Lalit', 'Raghuvanshi', 88000, '2016-09-26', 'Services'),
							 ('Sandeep', 'Kumar', 70000, '2015-02-01', 'Insurance');

go

 CREATE TABLE Incentives
(			IncentiveID  int Primary key identity(1,1),
            EmployeeRef          int foreign key references Employee (EmployeeId) ,
            IncentiveDate            date,
            IncentiveAmount      decimal(18,2)
)

insert into Incentives values(1, '2015-09-21', 10000),
(2, '2014-12-25', 8000), (3, '2015-05-30', 6000),
(1, '2016-09-12', 3000), (2, '2016-02-25', 11000);

go
select * from Employee
select * from Incentives
--1
Select *
from Employee,Incentives
-- c'est un produit cartesien 
Select *
from Employee EMP JOIN Incentives INC
on EMP.EmployeeId = INC.EmployeeRef -- c'est une jointure interne 

--2. Afficher les noms des employés, leurs dates d'entrée (JoiningDate) et leurs dates
--d'incitation (IncentiveDate).
select FirstName+ ' , ' +LastName as Nom  , JoiningDate , IncentiveDate 
from Employee
join  Incentives 
on EmployeeRef = EmployeeId ;
--3. Afficher les noms et le montant d'incitation pour les employés qui bénéficient d'incitatifs
select FirstName+ ' , ' +LastName as Nom ,IncentiveAmount
from Employee
join  Incentives 
on EmployeeRef = EmployeeId ;
--Afficher les noms et le montant d'incitation pour les employés qui bénéficient
--d'incitatifs avec un montant d'incitation supérieur à 5000.select FirstName+ ' , ' +LastName as Nom ,IncentiveAmount
from Employee
join  Incentives 
on EmployeeRef = EmployeeId 
where IncentiveAmount > 5000 ;
--Afficher les noms et le montant d'incitation pour tous les employés même s'ils n'ont pas
--reçu d'incitatifs.
select FirstName+ ' , ' +LastName as Nom ,IncentiveAmount
from Employee
left outer join  Incentives 
on EmployeeRef = EmployeeId ;
--Afficher les noms et le montant d'incitation pour tous les employés même s'ils n'ont pas
--reçu d'incitatifs et définir la valeur NULL sur 0 pour les employés qui n'ont pas reçu
--d'incitatifs
select FirstName+ ' , ' +LastName as Nom ,ISNULL(IncentiveAmount,0)
from Employee
left outer join  Incentives 
on EmployeeRef = EmployeeId 
select * from Employee
select * from Incentives