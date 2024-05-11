create database sales
go 
use sales
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


select * from salesman
select * from customer
select * from orders
--1  Trouver le vendeur et le client qui résident dans la même ville, afficher les noms et la ville.
select s.salesman_name ,s.city , c.cust_name ,c.city
from salesman s join customer c 
on c.city = s.city ;
--2 Trouver les commandes dont le montant (purch_amt) est compris entre 500 et 2000. Afficher le
--numéro de commande (ord_no), le montant (purch_amt), le client qui a effectué la commande
--(cust_name) et sa ville (city).select o.ord_no , o.purch_amt ,c.cust_name , c.city from orders o join customer c on o.customer_id = c.customer_idwhere purch_amt between 500 and 2000 ;--3 Trouver le(s) vendeur(s) et le(s) client(s) qu'il représente. Afficher le nom du client et sa ville, le
-- nom de vendeur et sa commission.select c.cust_name as 'Customer Name' , c.city as 'Customer City' , s.salesman_name as 'Salesman Name' , s.commissionfrom  customer c join salesman s on s.salesman_id = c.salesman_id ;--4. Trouver des vendeurs qui ont reçu des commissions de plus de 12 % (0.12). Afficher le nom du
--client et sa ville, le vendeur et sa commission.select c.cust_name as 'Customer Name' , c.city as 'Customer City' , s.salesman_name as 'Salesman Name' , s.commissionfrom  customer c join salesman s on s.salesman_id = c.salesman_idwhere commission > 0.12; --5. Trouver les vendeurs qui ne vivent pas dans la même ville où vivent leurs clients et qui ont reçu
--une commission de plus de 12 % (0.12). Afficher le nom du client et sa ville, le vendeur, sa ville
--et sa commission.select c.cust_name as 'Customer Name' , c.city as 'Customer City' , s.salesman_name as 'Salesman Name' , s.salesman_name as 'Salesman City'  ,s.commissionfrom  customer c join salesman s on s.salesman_id = c.salesman_id where s.city <> c.city and  commission > 0.12 ;--6 Afficher les détails d'une commande : order_id, order_date, purch_amt, Customer Name, grade,
--Salesman, commission.select o.ord_no as order_id  , o.ord_date as order_date , purch_amt , c.cust_name as 'Customer Name' , c.grade  ,  s.salesman_name as 'Salesman Name' , s.commissionfrom orders oinner join  customer c on o.customer_id = c.customer_id inner join salesman s on s.salesman_id = o.salesman_id ;--7 Afficher les détails des clients ayant un grade inférieur à 300. Afficher les informations suivantes :
--customer city, grade, salesman, salesman city. Les résultats doivent être triés par ordre croissant
--selon customer_id.select c.cust_name , c.city , grade , s.salesman_name as 'Salesman Name' , s.cityfrom customer c inner join salesman s on s.salesman_id = c.salesman_id where grade < 300 order by c.customer_id;--8. Combiner chaque ligne de la table salesman avec chaque ligne de la table customer.select * from salesman cross join customer;---9. Afficher les noms des clients ayant passer une commande supérieure à la moyenne de toutes les
--commandes select c.cust_name , purch_amtfrom customer c join orders o on c.customer_id  = o.customer_idwhere purch_amt > (select avg(purch_amt) from orders);

