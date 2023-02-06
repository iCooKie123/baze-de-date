===============================================
Modificarea valorilor inregistrarilor dintr-un tabel cu UPDATE

Structura:

update [TABEL] SET [COLOANA = ???] WHERE [criteriu pt selectarea liniilor care vor fi modificate] ORDER BY [COLOANA]
LIMIT ???;

1) [TABEL] este tabelul in care vrem sa modificam valori, el poate fi si un tabel compus din alte tabele
asociate prin inner join, left outer join, etc.
2) in clauza where putem specifica orice criteriu, ulterior
modificarile vor fi aduse numai liniilor din tabel care satisfac acel criteriu.

EXEMPLU: sa modificam pretul cartii cu id_carte='1234' din tabelul carti.
Vom fixa pretul la 5 , din 1 cat era initial

UPDATE carti SET pret = 5.0 WHERE id_carte='1234';

EXEMPLU: sa modificam orasul clientului cu cnp '1234'.

UPDATE clienti SET oras = 'Pitesti' WHERE cnp='1234';

se pot modifica si toate datele din intreaga coloana dintr-un tabel.

sa marim pretul la toate cartile cu o unitate.

UPDATE carti SET pret = pret+1;

Exemplu: Sa modificam numele ultimului client (ordonati dupa cnp).
update clienti set nume='nume_nou' order by id_client desc LIMIT 1;

Se poate face update pe tabele asociate

modificam numele clientului care a facut comanda cu id_comanda=4

update clienti natural join comenzi set nume='ANAMARIA' where id_comanda=4;

alta solutie

update clienti, comenzi set nume='ANAMARIA' where id_comanda=4 and comenzi.cnp=clienti.cnp;

Se poate copia o coloana dintr-un tabel temporar, rezultat al unei interogari peste alta coloana.

drop table if exists T1;
create table T1(c1 int, c2 int, c3 int);

insert into T1 values
(1,2,3),
(2,3,4),
(3,4,5);

update T1 join (select c1,c3 from T1) as t  on T1.c1=t.c1 set T1.c2= t.c3;

============================================

Modificarea tabelelor cu ALTER.

aceasta modificare se refera la adaugarea de noi coloane la anumite tabele,
schimbarea tipului de date pt valorile stocate pe anumite coloane, stergerea unor coloane existente,
adaugarea/stergerea de chei externe, primare,etc

Structura:

ALTER TABLE  [nume tabel] [instructiune];

unde [instructiune] poate fi
add column
modify column
change column
drop column

si multe altele, vedeti exemple mai jos.

adaugare de coloane intr-un tabel

alter table carti add column categorie varchar(30); 

sau
alter table carti add categorie varchar(30);

modificarea unui tip de date al valorilor dintr-o coloana data

alter table carti modify categorie varchar(40);

redenumirea unei coloane

alter table carti change column categorie catg varchar(30);


stergerea unei coloane

alter table carti drop column catg;



stergere cheie externa
show create table carti_comandate;
alter table carti_comandate drop foreign key `carti_comandate_ibfk_1`;

stabilire cheie externa

alter table carti_comandate add foreign key (id_carte) references carti(id_carte) on update cascade;

stergere cheie primara

create table T1(c1 int not null primary key, c2 int not null);



alter table T1 drop primary key;

definire cheie primara
alter table T1 add primary key(c2);


stergere de coloane dintr-un tabel

alter table [nume tabel] drop column c1, drop column c2;  

va sterge coloanele c1, c2 din tabelul [nume tabel].

mai sus column se poate omite
alter table [nume tabel] drop  c1, drop  c2;

Exemplu:
alter table carti drop catg; 

Resetare auto_increment


mysql> alter table comenzi auto_increment=6;

valoarea trebuie sa fie mai mare decat ultima valoare id_comanda din tabel.

==============================================

Stergerea de linii dintr-un tabel (atentie! operatia nu e reversibila) 


DELETE  from [tabel] WHERE [conditie pentru selectarea liniilor ce vor fi sterse] ORDER BY [COLOANA] ASC/DESC 
LIMIT ???;


[tabel] poate fi un tabel obtinut prin asociere cu inner join, left joint, etc, aveti un exemplu mai jos.
intr-o astfel de situatie trebuie sa specificam si din care tabel (dintre cele care participa la asociere)
vrem sa stergem linii. 


extraoptiuni  low priority --> se executa dupa ce nu mai citeste nimeni din tabel
order by  (in conjuctie cu Limit, revenim)

exemple

delete from carti;

va sterge toate liniile din tabelul carti (daca aceasta stergere e permisa de constrangerile legate de cheile externe).

delete from carti where id_carte='1239';

va sterge cartea cu id_carte='1239'.

se pot sterge oricate linii dintr-un tabel cata vreme se 
pot selecta acele linii utilizand un anume criteriu de identificare
a lor.

se pot sterge linii din mai multe tabele

delete t1,t2 from t1 inner join t2 on t1.id=t2.id inner join t3 on t2.id=t3.id where [conditie pentru selectia liniilor din t1, t2 ce vor fi sterse] 

aici t3 e folosit numai pentru cautare


sa stergem toti clientii care nu au nicio comanda

delete c from clienti as c left join comenzi as p on c.cnp=p.cnp where p.id_comanda is null;

Clauza Limit  (in mysql)  

select * from clienti limit 2;

returneaza primii 2 clienti din tabel;


select * from clienti order by id_client desc limit 2;

returnam ultimii 2 clienti din tabel;

sa stergem ultimii 2 clienti in ordine alfabetica dupa nume.

daca vrem doar sa-i afisam 

select * from clienti order by nume desc limit 2;

acum ii stergem

delete from clienti order by nume desc limit 2; 

==============================================

redenumirea unui tabel

rename table clienti to clienti2;

stergerea unui intreg tabel se poate face cu comanda

drop table [nume];
drop table clienti;

stergerea intregii baze de date se face cu comanda

drop database [nume baza]

Ex. Sa stergem baza creata anterior

drop database clinical5;
==============================================================

UPDATAREA tabelelor virtuale.

Un tabel virtual poate fi si updatat in anumite conditii restrictive (daca valoarea ce urmeaza a fi updatata nu provine din functii de comasare), practic updatarea se face direct in tabelul din care provine aceasta valoare in tabelul virtual;
Exemplu: 

create view comd(id_comanda,cnp, nume_client, valoare, data_p)
as
select p.id_comanda as id_comanda, p.cnp as cnp, c.nume as nume, p.valoare as valoare, p.data as data from clienti as c, comenzi as p where c.cnp=p.cnp;

desc comd;

se folosesc pentru a ascunde anumite detalii legate de interogarea care creeaza tabelul respectiv.

select * from comd;

update comd set nume_client='vasilica' where id_client=2;


============================================================================================

Tranzactii in MySQL


Uneori anumite interogari trebuiesc executate fie toate fie niciuna.

ex. Cont bancar

create table cont_bancar
( id_client int unsigned not null auto_increment primary key, 
  suma_totala double);

insert into cont_bancar(suma_totala) values
(10.5),
(20.5);

ysql> select * from cont_bancar;
+-----------+-------------+
| id_client | suma_totala |
+-----------+-------------+
|         1 |        10.5 |
|         2 |        20.5 |
+-----------+-------------+
2 rows in set (0.00 sec)


Sa transferam 5 RON de la primul la al doilea.

update cont_bancar set suma_totala=suma_totala-5 where id_client=1;
update cont_bancar set suma_totala=suma_totala+5 where id_client=2;

mysql> select * from cont_bancar;
+-----------+-------------+
| id_client | suma_totala |
+-----------+-------------+
|         1 |         5.5 |
|         2 |        25.5 |
+-----------+-------------+
2 rows in set (0.00 sec)

Trebuie ca Aceste 2 interogari sa fie executate ambele fie niciuna. In caz de probleme tehnice(conexiune, pc, etc) e posibil ca numai prima sa fie executata, ceea ce duce la erori.

Cum se implementeaza atomicitatea?

 Platforma functioneaza prin default in modul autocommit=1, adica odata ce  o interogare
e executata, efectul ei e ireversibil.

spre ex, dupa executarea 
update cont_bancar set suma_totala=suma_totala+1.0;
 
nu mai putem reveni la starea anterioara ( adica starea anterioara nu e stocata pe nicaieri).

mysql> update cont_bancar set suma_totala=suma_totala+1.0;
mysql> select * from cont_bancar;
+-----------+-------------+
| id_client | suma_totala |
+-----------+-------------+
|         1 |        11.5 |
|         2 |        21.5 |
+-----------+-------------+


pentru a evita asta(adica sa facem rezultatul oricarei interogari definitiv)
 putem executa

set autocommit=0;

rezultatul interogarilor executate dupa acest moment e stocat in baza numai temporar si nu e vazut decat de  utilizator (ceilalti utilizatori nu vad rezultatul interogarilor lui) .

acest rezultat e stocat permanent in baza numai dupa ce se executa:

commit 

daca se doreste sa se revina la starea dinainte de momentul cand s-a executat
autocommit=0

se va executa 

rollback;

Pentru a reveni la modul autocommit=1 (adica executia oricarei interogari e ireversibila) se executa
set autocommit=1;

Pentru a vizualiza modul autocommit existent la un moment dat se executa

select @@autocommit;

Exemplu: 

set autocommit=1;
update clienti set nume='Dan' where id_client=1;
set autocommit=0;
update clienti set nume='Lia' where id_client=1;
select * from clienti where id_client=1;
rollback; # revenim la starea anterioara
select * from clienti where id_client=1;

Alt exemplu:
set autocommit=1;
update clienti set nume='Dan' where id_client=1;
set autocommit=0;
update clienti set nume='Lia' where id_client=1;
select * from clienti where id_client=1;
commit; # facem modificarea definitiva, suntem inca in modul autocommit=0
select * from clienti where id_client=1;


TRANZACTII in mysql
Comanda

start transaction;

va functiona precum 'set autocommit=0' dar  numai pana la executarea primului commit sau rollback, dupa care se revine la modul autocommit=1. 


set autocommit=1;
update clienti set nume='Dan' where id_client=1;
start transaction;
update clienti set nume='Lia' where id_client=1;
select * from clienti where id_client=1;
rollback; % revenim la starea anterioara si iesim din modul autocommit=0
select * from clienti where id_client=1;


set autocommit=1;
update clienti set nume='Dan' where id_client=1;
start transaction;
update clienti set nume='Lia' where id_client=1;
select * from clienti where id_client=1;
commit; % facem schimbarea permanenta si iesim din modul autocommit=0
select * from clienti where id_client=1;



