create database TD9_ex2
go 

use TD9_ex2

go

create table client(
cin varchar(7) primary key,
nom varchar(20),
prenom varchar(20),
adr varchar(20),
tel varchar(20))

go

create table compte(
numcmp int primary key,
solde float,
typeCompte varchar(2) check(typeCompte ='CC' or typeCompte= 'CE'), --Un compte ne peut étre que de type Compte Courant (CC) ou Compte d'Epargne (CE)
numcl varchar(7) foreign key references client(cin))

go

create table operation(
numop int Identity(1,1) primary key, --Le numéro de l'opération est automatique
typeOp varchar check(typeOp ='R' or typeOp= 'D'), --Les opérations sont soit des dépôts 'D' ou des retraits 'R', 
montantOp float,
numcpt int foreign key references compte(numcmp),
dateOp datetime default getDate()) -- La date d'opération prend par défaut la date du jour

--Un client ne peut avoir qu'un seul compte courant mais plusieurs comptes d'épargnes.

insert into client values ('AZ100', 'nom1','prenom1','Agadir','0606060606'),
							('AZ200', 'nom2','prenom2','Rabat','0606060601');

insert into compte values (100,20000,'CC','AZ100'),
						(1001,22030,'CE','AZ200');

insert into operation (typeOp,montantOp,numcpt) values ('R', 100,	100),
													('D',500,1001);

--2. Créer un trigger qui interdit la suppression d'un compte dont le solde > 0.
create trigger tr2
on compte 
for delete
as
begin 
if(select solde from compte where numcmp = 
(select numcmp from deleted  ))>0
rollback
print 'impossible de supprimer ';
end

delete from compte where numcmp = 100;
--Créer un trigger qui interdit la modification de solde des comptes auxquels sont associées des
--opérations.
create trigger tr3
on compte 
for update 
as 
begin
if update(solde)
begin 
if (select count(numop) from operation where numcpt = (select 
numcpt from inserted )) > 0 
begin
rollback 
end 
end 
end 
update compte set solde = 20010 where numcmp = 100;
--Créer un trigger qui interdit le changement d’un compte CE en CC (le contraire étant possible)
create trigger tr4
on compte 
for update 
as 
begin 
if update(typeCompte)
begin 
declare @type_new varchar(2)
declare @type_old varchar(2)
set @type_new = (select typeCompte from inserted)
set @type_old = (select typeCompte from deleted)
if(@type_old='CE' and @type_new='CC')
Rollback
end 
end
select * from client
select * from compte
select * from operation
--5. Créer un trigger qui, à la modification de numéro de téléphone d’un client, vérifie si le nouveau
--numéro, n'est pas attribué à un autre client.
create trigger tr6
on client 
for update 
as 
begin
if(update(tel))
begin 
if (select tel from inserted) in (select tel from client)
begin 
rollback
end
end
end