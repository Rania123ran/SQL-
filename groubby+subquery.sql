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
--1 les commande passé par le vendeur Paul Adam
select * from orders 
where salesman_id = ( select salesman_id from salesman where salesman_name = 'Paul Adam');
--2 les commande passé par les vendeurs basés à London
select * from orders 
where salesman_id in (select salesman_id from salesman where city='London') ;
--3 les commandes generees par les vendeurs susceptiv=ble de travailler avec le client dont l'id 3007
select * from orders 
where salesman_id  = 
(select salesman_id from customer where customer_id = 3007) ;
--4 les cmd dont purch_amt est superieure à la valeur moyenne des cmd de 10 oct 2012 
select * from orders  where purch_amt >
( select avg(purch_amt) from orders where ord_date = '2012-10-10') ;
--5 toutes le commande generer à new york 
select * from orders where salesman_id = (
select salesman_id from salesman where city = 'New York') ;
--6 nombre de clients avec la grade superieur a la moyenne dans la ville new york ;
select count(*) from customer where grade >
(select avg(grade) from customer where city = 'New York');
--7 pour chaque grade afficher le nombre de clients avec des notes (grade) supérieures à la moyenne dans la ville NY.
select grade ,count(cust_name) as 'nombre clients' from customer where grade >
(select avg(grade) from customer where city = 'New York')
group by grade ;
--8 afficher la note la plus élevée des clients dans chaque ville 
select city  , max(grade) as grad_max from customer 
group by city ;
--9 afficher le montant d'achat le plus elevé commandé par chaque client :
select customer_id , max(purch_amt) as max_purch_amt from orders 
group by customer_id;
--10 afficher le montant de commande (purch_amt) le plus elevé et supérieur à 2000 pour chaque client et pour chaque date 
select customer_id ,ord_date,MAX(purch_amt) from orders
group by customer_id,ord_date
having MAX(purch_amt)>2000;
--11 afficher le montant de cmd (purch_amt) le plus élevé dans la plage 1000-6000 pour chaque client et pour chaque date 
select customer_id ,ord_date,MAX(purch_amt) from orders
group by customer_id,ord_date
having MAX(purch_amt) between 1000 and 6000;
--12 nombre de cmd générer par chaque vendeur ;
select salesman_id ,count(ord_no) from orders 
group by salesman_id ;
--13 afficher les noms de vendeurs qui ont géneré plus de 2 cmd
select salesman_id ,salesman_name from salesman  where salesman_id IN (
select salesman_id  from orders 
group by salesman_id 
having count(ord_no)>2);
--14 afficher les commandes générees par les vendeurs qui ont gagné un commission maximale ;
select * from orders where salesman_id = (select salesman_id from salesman where commission = (
select max(commission) from salesman)) ;
--15 afficher les vendeurs qui avaient plus d'un client 
select salesman_id,salesman_name from salesman  a where salesman_id in ( 
select salesman_id as nbr from customer group by salesman_id having count(customer_id)>1)  ;
--afficher le nombre de commandes effectuées et la somme totale des montants d'achat pour chaque date 
select ord_date , count(ord_no) as 'number of orders' ,sum(purch_amt) as 'sum of purch_amt' from orders
group by ord_date ;
-- 17 afficher le nombre de cmd passées par chaque client 
select cust_name ,(select count(*) from orders where  orders.customer_id = customer.customer_id) as nbr from customer ;
--18 produit cartesien entre table salesman et customer a cnd d'afficher qui appartient à une ville différente de celle de leurs 
--- et client doivent avoir leurs propre notes 
select * from salesman s ,customer c
where s.city <> c.city and grade is not NULL;
--19 afficher les clients dont les notes ne sont pas les mmemes que ceux qui vivent à Londres 
select * from customer where grade not in (
select grade from customer where city = 'London' and not grade is null) ;
--20 affiher tous les clients qui ont passé plus de deux cmd avec exists
select customer_id , cust_name from customer c where  exists
(select customer_id ,COUNT(ord_no) from orders o where c.customer_id =o.customer_id
group by customer_id  having count(ord_no)>2 )
select * from customer
select * from orders
select * from salesman




