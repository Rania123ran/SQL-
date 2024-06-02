

/*###############################################################################################################################
*********************************   TEST 2: Base de donn�es relationnelles 15/05/2024  ******************************************
************************************            Groupe A             ************************************************************
*********************************************************************************************************************************
################################################################################################################################*/

--Nom & Pr�nom........................................

Create database test2_A

go 

use test2_A

go 
create table Clients (
id_client int primary key,
n_passport varchar(10),
nom varchar(25),
prenom varchar(25),
date_naissance date,
pays_origine varchar(50)
)

go
create table chambres(
n_chambre int primary key,
type_chambre varchar(255),
surface int)

go

create table reservation (
id_reservation varchar(50) primary key,
id_client int,
debut_sejour date,
fin_sejour date,
n_chambre int foreign key references chambres(n_chambre),
nombre_nuits int,
montant money
)

go

insert into Clients values (17852,'E000265','NIEHS','Stephan','1990-12-05','Allemagne'),
							(02389,'FN26301','RILEY','Lisa','1986-04-27','USA'),
							(56723,'SU85623','KIMBERLEY','George','1996-09-02','USA'),
							(90147,'P400128','ROUXEL','Victoria','1975-11-14','France'),
							(47231,'R894470','MAIER','Chris','1982-03-18','Allemagne'),
							(84203,'SN50052','ULRICH','Mathias','1993-01-26','Allemagne')

go

insert into chambres values (10,'Chambre individuelle',15),
							(11,'Chambre Double',20),
							(12,'Chambre Double',23),
							(13,'Suite',52),
							(14,'Suite',45)
go

insert into reservation values ('RES_001523',90147,'2022-06-18','2022-06-24',14,6,1710),
							   ('RES_045238',02389,'2022-07-02','2022-07-06',11,4,480),
							   ('RES_368952',01275,'2022-07-11','2022-07-20',13,9,2430),
							   ('RES_100256',84203,'2022-07-24','2022-07-29',10,5,475),
							   ('RES_256007',90147,'2022-08-06','2022-08-10',12,4,520),
							   ('RES_0063689',56723,'2022-08-11','2022-08-18',11,7,675)

/*###############################################################################################################################
################################################################################################################################*/
/* 1. Ecrire une requ�te renvoyant l'ID de chaque r�servation, le nom, pr�nom du client, la date de d�but de s�jour, 
de fin de s�jour et le montant pay� par les clients (afficher toutes les sr�servations effectu�es), Ecrire deux  requ�tes 
qui revoient le m�me r�sultat en utilisant LEFT JOIN et RIGHT JOIN.*/
select id_reservation , nom , prenom , debut_sejour , fin_sejour
from reservation r
left join Clients c
on  c.id_client = r.id_client ;
------------------------------
select id_reservation , nom , prenom , debut_sejour , fin_sejour
from Clients c
right join reservation r
on  c.id_client = r.id_client  ;
/*2. Interpr�ter le r�sultat de cette requ�te:*/
select clt.id_client, clt.nom, clt.prenom, res.id_reservation, res.debut_sejour,res.fin_sejour
from Clients clt
full join reservation res on res.id_client=clt.id_client
-- R�ponse: c'est une jointure complete qui affiche tous les reservation y a qu'elle sont resevé sans clients et y a des clients 
--sans reservation.
/* 3. Ecrire une requ�te renvoyant l'ID de chaque r�servation, le nom, pr�nom et N� de passport des clients, 
date de d�but de s�jour, de fin de s�jour des clients d'origines des �tats-unis */
select r.id_reservation , c.nom , c.prenom , c.n_passport  ,r.debut_sejour , r.fin_sejour 
from reservation  r
join clients c
on r.id_client = c.id_client
where  pays_origine = 'USA' ;
/* 4. Ecrire une requ�te renvoyant l'ID de chaque r�servation, le nom et pr�nom du client, nombre de nuits de chaque r�servation
et montant pay�: cette requ�te n'affichera que les r�servations qui concernent les chambres doubles, apr�s ordoner le r�sultat 
selon un ordre d�croissant de l'�ge des clients.*/
select r.id_reservation , c.nom , c.prenom , r.nombre_nuits ,r.montant ,date_naissance
from reservation  r
join clients c on r.id_client = c.id_client 
join chambres ch on ch.n_chambre = r.n_chambre 
where type_chambre = 'Chambre Double'
order by c.date_naissance  ;
/*5. Ecrire une requ�te renvoyant le nom, pr�nom, N� de passport et pays d'origine des clients ayant s�journ� dans
un h�tel 5 nuits ou plus*/
select  c.nom , c.prenom , c.n_passport , c.pays_origine
from reservation  r
join clients c on r.id_client = c.id_client 
where nombre_nuits >=5;

/* 6. Ecrire une requ�te renvoyant  le nom, le pr�nom et le nombre de r�servations pour chaque client, mais pour les clients 
ayant effectu� au moins 2 r�servations */
select clt.nom , clt.prenom , count(*) as 'nombre reservation' 
from Clients clt  , reservation res
where clt.id_client=res.id_client 
group by clt.nom , clt.prenom 
having  count(*) >= 2 ;
/* 7. Ecrire une requ�te renvoyant  le nombre de client par pays */
select pays_origine,count(*) as 'nbr clients' from Clients group by pays_origine ;
/* 8. Cr�er un trigger qui interdit la modification dans la table Clients.*/
create trigger tr1 
on Clients 
for update 
as begin
print ('Modification non autorise')
rollback
end 

/*9 . Cr�ez un trigger qui, lors de l'insertion (ou de la mise � jour) d'une r�servation, v�rifie si la date de d�but du s�jour 
est inf�rieure � la date de fin du s�jour. Effectuer un test pour voir l'effet de trigger.*/
create trigger tr2 
on reservation
for update , insert  
as 
begin 
if((select debut_sejour from inserted)>(select fin_sejour from inserted))
print'impossible';
rollback
end 

insert into reservation values ('RES_00553',90147,'2023-01-18','2022-06-24',14,6,1710)

/*10. Les clients b�n�ficient d'une remise de 10 % entre le 01/05/2023 et le 31/05/2023. Cr�ez un d�clencheur qui v�rifie 
cette condition (si la condition est vraie, au lieu d'ins�rer le montant normal, nous impliquons une remise de 10 %)*/
create trigger tr3
on reservation 
instead of insert  
as 
begin 
if((select debut_sejour from inserted)>='2023-05-01' and (select fin_sejour from inserted)>='2023-05-31')
begin 
insert into reservation select * from inserted 
update reservation set montant = montant + montant*0.1 where id_reservation = (select id_reservation from inserted)
end 
else 
insert into reservation select * from inserted
end
/* 11.  Cr�ez un trigger qui, lors de l'insertion (ou de la mise � jour) d'une r�servation, v�rifie si le nombre de nuits
ins�r�
est correct d'apr�s les dates de s�jour ins�r�es*/
create trigger tr4 
on reservation 
for insert,update 
as 
begin 
if (DATEDIFF(day,(select debut_sejour from inserted),(select fin_sejour from inserted)) <> (select nombre_nuits from inserted)) 
rollback 
end 

/*12. D�sactiver le trigger cr�e dans la question 9*/
disable trigger tr4 on reservation ;
/* 13. Ecrire une requ�te renvoyant les noms et pr�noms des clients qui n'ont jamais fait de r�servation */
select nom,prenom,id_reservation 
from Clients left join reservation 
on Clients.id_client=reservation.id_client 
where id_reservation is null

select * from chambres
select * from Clients
select * from reservation
/*###############################################################################################################################
*****************************************************************************************   Bon courage  ************************
################################################################################################################################*/