
exemplele sunt lucrate pe baza de la laboratorul 7



SELECT [expresie de afisare] FROM [tabele] ON [clauza de asociere a tabelelor] WHERE [conditie de filtrare a liniilor] GROUP BY [ coloane dupa care se face gruparea liniilor] HAVING [CONDITIE] ORDER BY [coloana/coloanele] [ASC/DESC]  LIMIT [nr de linii selectate];


CAUTARE IN MAI MULTE TABELE
=========================================================
Asociere completa(produs cartezian): 

sinonime-->
JOIN
INNER JOIN
CROSS JOIN


Fie 2 tabele T1, T2.


drop table if exists T1;
create table T1(
c1 int,
c2 int);

drop table if exists T2;
create table T2(
c3 int,
c4 int);


insert into T1 values
(1,2),
(3,4);

insert into T2 values
(1,5),
(6,7);

mysql> select * from T1;
+------+------+
| c1   | c2   |
+------+------+
|    1 |    2 |
|    3 |    4 |
+------+------+

mysql> select * from T2;
+------+------+
| c3   | c4   |
+------+------+
|    1 |    5 |
|    6 |    7 |
+------+------+


interogarea 


select * from T1 join T2;

va selecta fiecare linie din T1 completata cu fiecare linie din T2.

MariaDB [l7]> select * from T1 join T2;
+------+------+------+------+
| c1   | c2   | c3   | c4   |
+------+------+------+------+
|    1 |    2 |    1 |    5 |
|    3 |    4 |    1 |    5 |
|    1 |    2 |    6 |    7 |
|    3 |    4 |    6 |    7 |
+------+------+------+------+
4 rows in set (0.00 sec)



Ex 5). Afisati fiecare linie din clienti completata cu fiecare linie din comenzi.

select * from clienti join comenzi;
select * from clienti cross join comenzi;
select * from clienti, comenzi;
============================================================

INNER JOIN

T1 INNER JOIN T2 ON (CONDITIE DE ASOCIERE) --> se va asocia o linie din T1 cu o linie din T2 numai daca cele doua linii satisfac CONDITIA DE ASOCIERE.

ex5') select * from T1 inner join T2 on T1.c1=T2.c3; 

Conditia de asociere poate fi specificata si in clauza where

 select * from T1 inner join T2 where T1.c1=T2.c3; 



Ex 6) Afisam comenzile impreuna cu numele celor care le-au plasat

select clienti.nume, comenzi.* from clienti INNER JOIN comenzi ON clienti.cnp=comenzi.cnp; 

Pt o scriere simplificata se pot folosi aliasuri pentru tabele
Ex 7)  
select c.nume, co.* from clienti as c INNER JOIN comenzi as co on c.cnp=co.cnp; 



Ex 7') Se poate obtine acelasi efect prin filtrarea liniilor dorite in clauza where

select c.nume, co.* from clienti as c , comenzi as co where c.cnp=co.cnp; 



Se pot asocia mai mult de 2 tabele. 



Ex8) Afisam fiecare carte(titlu) cumparata impreuna cu numele celui care a cumparat-o.

select c.nume, p.id_carte, p.titlu  from clienti as c join comenzi as co on c.cnp=co.cnp inner join carti_comandate as pc on pc.id_comanda=co.id_comanda inner join carti as p on pc.id_carte=p.id_carte;

===================================================================

Alte tipuri de JOIN

LEFT OUTER JOIN

T1 LEFT OUTER JOIN  T2    --> fiecare linie din T1 e completata cu o linie din T2 daca e satisfacuta conditia specificata, iar daca o linie din T1 nu are corespondent in T2 atunci  acea linie sa va completa cu o linie ce contine numai valori nule.

Spre exemplu

select * from T1 left join T2 on T1.c1=T2.c3;

alt exemplu

select clienti.*, comenzi.* from clienti left outer join comenzi on clienti.cnp=comenzi.cnp;

va completa cu NULL in dreptul clientilor care nu au plasat nicio comanda.


Ex 9. Aflati toti clientii care n-au plasat nicio comanda.
select clienti.*  from clienti left outer join comenzi on clienti.cnp=comenzi.cnp where comenzi.id_comanda IS NULL;


 Similar se defineste RIGHT OUTER JOIN


select * from T1 RIGHT JOIN T2 on T1.c1=T2.c3;

=================================================================

Reuniunea a doua rezultate din interogari SELECT  se face cu comanda 

UNION --> se elimina linii comune in cele 2 tabele
UNION ALL ---> nu se elimina liniile comune


Ex9'')
  SELECT * FROM T1
  LEFT JOIN T2 ON T1.c1 = T2.c3
  UNION ALL
  SELECT * FROM T1
  RIGHT JOIN T2 ON T1.c1 = T2.c3;



Ex9'')
 SELECT * FROM T1
  LEFT JOIN T2 ON T1.c1 = T2.c3
  UNION 
  SELECT * FROM T1
  RIGHT JOIN T2 ON T1.c1 = T2.c3;


=================================================================
FULL OUTER JOIN   se interpreteaza ca (LEFT JOIN ) UNION (RIGHT JOIN)
=================================================================
NATURAL JOIN 

Este similar cu innner join fara specificatia conditiei ce trebuie indeplinita, care se subintelege (de aici si denumirea de 'natural'), in sensul ca cele 2 tabele asociate prin natural join au  campuri comune (cu acelasi nume) si prin acestea se va face legatura

Ex10) Afisati toate comenzile impreuna cu numele clientilor care le-au dat.

select clienti.nume, comenzi.* from clienti natural join comenzi;

======================================================================

--------------------
ALIASURI pentru tabele

Alias-uri se foloses pt o scriere mai compacta a interogarilor dar de asemenea si pentru proiectarea de subinterogari si folosirea de tabele temporare( discutam despre acestea ceva mai tarziu).


iata un exemplu simplu 


afisati toate comezile(nume client, valoare) de valoare > 2
  

Ex12) select cl.nume, co.valoare from clienti as cl, comenzi as co where co.valoare>3 and cl.cnp=co.cnp;


vom reveni la ele mai tarziu.

---------------------------------
Stocarea tabelelelor produse de SELECT

Rezultatul unei interogari de tip select este un tabel iar numele campurilor din acest tabel sunt exact numele campurilor ce 
se doreste a fi afisate (specificate dupa cuvantul cheie SELECT)

Ex12a) Afisati toate comenzile impreuna cu numele clientilor care le-au plasat.
select cl.cnp, cl.nume, co.id_comanda, co.valoare from clienti cl join comenzi co on cl.cnp=co.cnp;

Astfel de tabele pot fi stocate in baza cu o constructie de tip  CREATE  ... SELECT ...

Ex) Creati un tabel numit cnp care sa contina cnp, numele lui, id_comanda, valoare comanda

create table clienti_ex select cl.cnp, cl.nume, co.id_comanda, co.valoare from clienti cl join comenzi co on cl.cnp=co.cnp;



O comanda de tipul

create table cl1 select cl.cnp, comenzi.* from clienti cl join comenzi co  on clienti.cnp=co.cnp;

va da eroare pt ca vom avea doua campuri cu acelasi nume (cnp), trebuie sa folosim alias pt a redenumi
unul din aceste campuri  

select cl.cnp as id, co.* from clienti cl join comenzi co  on cl.cnp=co.cnp;

======================================================================================================

Stocarea ca TABEL VIRTUAL  a unui tabel rezultat al unei interogari 

se foloseste constructia  (parantezele drepte se vor omite)

CREATE VIEW nume_interog  AS [interogare SELECT]

ex) Afisati toate comenzile impreuna cu numele clientilor care le-au plasat si numiti COMZ aceasta interogare .


CREATE VIEW COMZ AS select cl.cnp, cl.nume, co.id_comanda, co.valoare from clienti cl join comenzi co on cl.cnp=co.cnp;


select * from COMZ;


putem vizualiza comanda de creare a acelui tabel virtual.

show create view COMZ;
 

vizualizare toate tabelele virtuale

select table_schema, table_name from information_schema.tables where table_type like 'view';
==============================================================================

SORTARI

se fac adaugand dupa scrierea criteriilor de selectie 

ORDER BY [NUME CAMP] ASC 

pt ordonare ascendenta sau

ORDER BY [NUME CAMP] DESC 

pt ordonare descendenta. prin default, daca nu se specifica tipul de ordonare, aceasta este ascendenta.

Exemplu:
Afisati toate comenzile(id comanda, cnp,valoare)
de valoare 4, in ordinea descendenta a valorii.


Ex) select id_comanda,cnp, valoare from comenzi where valoare>2 order by valoare desc;


Exemplu:
Afisati toate comenzile(NUME CLIENT, id programare, cnp,valoare)
de valoare >2, in ordinea descendenta a valorii.


 select c.nume, co.id_comanda,co.cnp, co.valoare from clienti as c, comenzi as co where co.cnp=c.cnp and co.valoare>2 order by valoare desc;


pe campurile cu valori text ordonarile se refera la ordinea alfabetica ascendenta sau descendenta.

---------------------------------------

FUNCTII DE COMASARE

AVG, COUNT, MAX, MIN, STD, SUM

count(*) ---> nr de inregistrari
count(coloana) nr de valori NENULE din coloana respectiva
count(distinct coloana) nr de valori distincte, nenule din coloana respectiva.

AVG,STD nu iau in considerare valorile nule. 


Exemplu

Ex) Media valorii comenzilor inregistrate in 2017.


 select avg(valoare) from comenzi where year(data)=2017;


Ex) Cati clienti au fost inregistrati in 2017?

select count(cnp) from clienti where year(data_inregistrarii)=2017;

Ex) Care e cea mai mare valoare din tabelul comenzi?

select max(co.valoare) from comenzi as co;


Ex) valorile nule nu sunt numarate
select count(tel) from clienti;

-------------------------------------



