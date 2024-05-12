create database sales1
go 
use sales1
go
--drop table orders
--drop table customer
--drop table salesman


/****************** salesman*******************/
create table salesman
(
salesman_id int primary key,
salesman_name     varchar(50),
city    varchar(50),
commission decimal(5,2)
)


go

/****************** customer*******************/
 create table customer
 ( 
 customer_id int primary key,
 cust_name    varchar(50),
 city   varchar(50),
 grade int,
 salesman_id int foreign key references salesman(salesman_id)
 )

 go
 /****************** orders*******************/
  create table orders(
  ord_no int primary key,
  purch_amt decimal(10,3),
  ord_date date,  
  customer_id int foreign key references customer(customer_id),
  salesman_id int foreign key references salesman(salesman_id)
  )

   go
  /****************** salesman*******************/
   insert into salesman values 
        (5001 , 'James Hoog' , 'New York' ,       0.15),
        (5002 , 'Nail Knite' , 'Paris'    ,       0.13),
        (5005 , 'Pit Alex'   , 'London'   ,       0.11),
        (5006 , 'Mc Lyon'    , 'Paris'    ,       0.14),
        (5007 ,'Paul Adam'  , 'Rome'     ,      0.13),
        (5003 , 'Lauson Hen' , 'San Jose' ,      0.12);

		select * from salesman

/****************** customer*******************/
 insert into customer values 
       ( 3002 , 'Nick Rimando'   , 'New York'  ,   100 ,  5001),
       ( 3007 , 'Brad Davis'    , 'New York'  ,   200 ,  5001),
       ( 3005 , 'Graham Zusi'    , 'California' ,   200 ,  5002),
       ( 3008 , 'Julian Green'   , 'London'    ,   300 ,  5002),
       ( 3004 , 'Fabian Johnson' , 'Paris'     ,   300 ,  5006),
       ( 3009 , 'Geoff Cameron'  , 'Berlin'     ,   100 ,  5003),
       ( 3003 , 'Jozy Altidor'   , 'Moscow'    ,   200 ,  5007);

insert into customer (customer_id,cust_name, city,salesman_id)  values   ( 3001 , 'Brad Guzan' , 'London'  ,   5005);

select * from customer
 /****************** orders*******************/
insert into orders values 
(70001   ,    150.5   ,    '2012-10-05' , 3005    ,     5002),
(70009   ,    270.65  ,    '2012-09-10' , 3001    ,     5005),
(70002   ,   65.26    ,   '2012-10-05'  , 3002     ,    5001),
(70004   ,    110.5   ,    '2012-08-17' , 3009    ,     5003),
(70007   ,    948.5   ,    '2012-09-10' , 3005    ,     5002),
(70005   ,    2400.6  ,    '2012-07-27' , 3007    ,     5001),
(70008   ,    5760    ,    '2012-09-10' , 3002    ,     5001),
(70010   ,    1983.43 ,    '2012-10-10' , 3004    ,     5006),
(70003   ,    2480.4  ,    '2012-10-10' , 3009    ,    5003),
(70012   ,    250.45  ,    '2012-06-27' , 3008    ,    5002),
(70011   ,    75.29   ,    '2012-08-17' , 3003    ,     5007),
(70013   ,    3045.6   ,   '2012-04-25' , 3002    ,     5001);
--1. Créer un trigger qui interdit la modification dans la table orders. Effectuer un test.
create trigger tr1
on orders
for update 
as 
begin 
rollback
print 'impossible de modifier la table '
end
--test :
--update orders set purch_amt = 160.500 where ord_no = 70001 ;
--2. Créer un trigger qui affiche les nouvelles lignes insérées dans la table customer. Effectuer un test.
create trigger tr2
on customer 
for insert 
as 
begin 
	select * from inserted ; 
end 
--test :
insert into customer values     ( 3010 , 'Jozy elan'   , 'Moscow'    ,   200 ,  5007);
--3. Créer un trigger qui affiche la nouvelle ville ainsi que l’ancienne lorsqu’une modification de la colonne
--city est effectuée sur une ligne de la table customer. Effectuer un test
create trigger tr3 
on customer 
for update 
as 
begin 
if update(city) 
	declare @ancien_ville varchar(15)
	declare @nouvelle_ville varchar(15)
	set @ancien_ville = (select city from deleted ) 
	set @nouvelle_ville = (select city from inserted ) 
	print 'nouvelle ville :'+ @nouvelle_ville
	print 'ancien ville :' + @ancien_ville 
end

--test :
update customer set city='London'  where customer_id = 3001 ;
--4. Créer un trigger qui empêche la modification de salesman_id dans la table customer
create trigger tr4 
on customer 
for update 
as 
begin
if update(salesman_id)
rollback 
print 'impossible de modifier l id du vendeur'
end
--test :
update customer  set salesman_id = 5005 where customer_id = 3002 ;
--5. Supprimer la contrainte d’intégrité référentielle (clé étrangère) dans la table customer : salesman_id int
--foreign key references salesman(salesman_id), et refaire l’implémentation de cette contrainte par un
--trigger. Effectuer un test.
alter table customer 
drop constraint [FK__customer__salesm__4BAC3F29]
create trigger tr5
on customer 
for insert 
AS
BEGIN
	if (select salesman_id  from inserted) not in (select salesman_id  from salesman)
	BEGIN
		PRINT('La valeur fournie de salesman_id n''exist pas')
		ROLLBACK
	END
END
--Créer un trigger qui vérifie le grade d’un client qui doit être compris entre 100 et 800 :
--100<=grade<=800
create trigger tr6 
on customer 
for insert, update 
as 
begin 
if (select grade from inserted ) not between 100 and 800
	begin
		rollback
	end
end
--test :
insert into customer values ( 3014 , 'Jozy Altidor'   , 'Moscow'    ,   0 ,  5007)

select * from orders
select * from salesman
select * from customer