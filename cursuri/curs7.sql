

INTEROGARI DE TIP INSERT IN MYSQL



In ce mod sql lucreaza platforma prin default?
MariaDB [(none)]> select version();
+-----------------+
| version()       |
+-----------------+
| 10.4.14-MariaDB |
+-----------------+
1 row in set (0.001 sec)

MariaDB [(none)]> SELECT @@GLOBAL.sql_mode;
+-----------------------------------------------------+
| @@GLOBAL.sql_mode                                   |
+-----------------------------------------------------+
| NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION |
+-----------------------------------------------------+
1 row in set (0.000 sec)

MariaDB [(none)]> SELECT @@SESSION.sql_mode;
+-----------------------------------------------------+
| @@SESSION.sql_mode                                  |
+-----------------------------------------------------+
| NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION |
+-----------------------------------------------------+
1 row in set (0.000 sec)


Sa efectuam urmatorul experiment:

vom seta modul sql ca fiind non-strict sql
SET sql_mode = '';

apoi rulam

use lib4;

#vom crea un tabel t1; observati ca ambele campuri sunt not null
use lib4;
drop table t1;
create table t1(x1 int not null, x2 int not null);
#inseram urmatoarea valoare
insert into t1(x1) values(1);

select * from t1;

observam ca a for inserata o linie cu valoarea 0 pt t2 care e specificat not null !!!!


#Acum setam platforma pe  strict-sql mode
SET GLOBAL sql_mode = 'STRICT_ALL_TABLES';
SET  sql_mode = 'STRICT_ALL_TABLES';

repetam experimentul
#vom crea un tabel t1; observati ca ambele campuri sunt not null
drop table t1;
create table t1(x1 int not null, x2 int not null);
#inseram urmatoarea valoare
insert into t1(x1) values(1);

#de aceasta data va fi returnat un mesaj de eroare.





Interogari de tip INSERT




INSERT       INTO NUME_TABEL(camp1, camp2,...) values(val1, val2,...);



Sa consideram tabelul:

create table clienti(
id_client int unsigned not null auto_increment primary key,
nume varchar(20) not null,
an_nastere int DEFAULT 1997,
data_inreg DATE  
  );


#inserare standard, valoarea in id_client se auto-completeaza.

mysql> insert into clienti(nume, an_nastere, data_inreg) values('ion',1990,'2019-10-23');
Query OK, 1 row affected (0.00 sec)

mysql> select * from clienti;
+-----------+------+------------+------------+
| id_client | nume | an_nastere | data_inreg |
+-----------+------+------------+------------+
|         1 | ion  |       1990 | 2019-10-23 |
+-----------+------+------------+------------+


#putem omite lista campurilor dar mai apoi trebuie sa precizam valorile TUTUROR CAMPURILOR in ordinea in care campurile au fost create
Observati ca valoarea id_client se va completa cu NULL

mysql> insert into clienti   values(NULL,'ana',1978,'2019-10-24');
Query OK, 1 row affected (0.01 sec)

mysql> select * from clienti;
+-----------+------+------------+------------+
| id_client | nume | an_nastere | data_inreg |
+-----------+------+------------+------------+
|         1 | ion  |       1990 | 2019-10-23 |
|         2 | ion  |       1990 | 2019-10-23 |
|         3 | ana  |       1978 | 2019-10-24 |
+-----------+------+------------+------------+


#Putem preciza numai o parte din campurile in care vrem sa inseram valori. PENTRU CAMPURILE CARE NU SUNT SPECIFICATE IN LISTA:

daca un camp creat cu o valoare default nu e specificat in lista atunci el se completeaza automat de mysql cu acea valoare DEFAULT (daca nu a fost precizata o valoare de default atunci depinde de modul sql in care se ruleaza)

daca un camp care nu are asociata o valoare default si este creat ca NOT NULL nu e specificat in lista atunci in modul strict sql in care lucram noi va fi specificat un mesaj de eroare. (exceptie fac campurile auto_increment care nu trebuie mentionate, ele se auto-incrementeaza)

daca un camp nu are asociata o valoare default si NU este creat ca NOT NULL  atunci se va insera AUTOMAT valoarea NULL.

EXEMPLE:
id_client int unsigned not null auto_increment primary key,
nume varchar(20) not null,
an_nastere int DEFAULT 1997,
data_inreg DATE 


OMITEM an_nastere si data_inreg

mysql> insert into clienti(nume) values('maria');
Query OK, 1 row affected (0.01 sec)

mysql> select * from clienti;
+-----------+-------+------------+------------+
| id_client | nume  | an_nastere | data_inreg |
+-----------+-------+------------+------------+
|         1 | ion   |       1990 | 2019-10-23 |
|         2 | ion   |       1990 | 2019-10-23 |
|         3 | ana   |       1978 | 2019-10-24 |
|         4 | maria |       1997 | NULL       |
+-----------+-------+------------+------------+



#la inserarea unei valori intr-o coloana se pot folosi valorile din coloanele precedente


create table test(
t1 int,
t2 int,
t3 int  
  );

mysql> insert into test(t1,t2) values(10,3*t1);
Query OK, 1 row affected (0.01 sec)

mysql> select * from test;
+------+------+------+
| t1   | t2   | t3   |
+------+------+------+
|   10 |   30 | NULL |
+------+------+------+


#se pot insera mai multe linii simultan

insert into test(t1,t2,t3) values
(10,20,30),(40,50,60),(70,80,90);

mysql> select * from test;
+------+------+------+
| t1   | t2   | t3   |
+------+------+------+
|   10 |   30 | NULL |
| NULL |   10 | NULL |
|   10 |   20 |   30 |
|   40 |   50 |   60 |
|   70 |   80 |   90 |
+------+------+------+
5 rows in set (0.00 sec)


#se poate insera un bloc intreg  daca exista compatibilitate;  


create table test1(
x1 int,
x2 int
  );

insert into test1 values
(1,2),
(3,4),
(5,6);

mysql> select * from test1;
+------+------+
| x1   | x2   |
+------+------+
|    1 |    2 |
|    3 |    4 |
|    5 |    6 |
+------+------+

#acum inseram tot continutul lui test1 pe primele doua coloane din test.

insert into test(t1,t2) select * from test1;
mysql> select * from test;
+------+------+------+
| t1   | t2   | t3   |
+------+------+------+
|   10 |   30 | NULL |
| NULL |   10 | NULL |
|   10 |   20 |   30 |
|   40 |   50 |   60 |
|   70 |   80 |   90 |
|    1 |    2 | NULL |
|    3 |    4 | NULL |
|    5 |    6 | NULL |
+------+------+------+


acum inseram tot continutul lui test1 pe ultimele doua coloane din test.

insert into test(t2,t3) select * from test1;
mysql> select * from test;
+------+------+------+
| t1   | t2   | t3   |
+------+------+------+
|   10 |   30 | NULL |
| NULL |   10 | NULL |
|   10 |   20 |   30 |
|   40 |   50 |   60 |
|   70 |   80 |   90 |
|    1 |    2 | NULL |
|    3 |    4 | NULL |
|    5 |    6 | NULL |
| NULL |    1 |    2 |
| NULL |    3 |    4 |
| NULL |    5 |    6 |
+------+------+------+

=========================================================================================



Interogari de tip SELECT (interogari de selectie/cautare si afisare) in MySQL

Au structura:

select * from clienti;

SELECT [expresie de afisare] FROM [tabele] ON [clauza de asociere a tabelelor] WHERE [conditie de filtrare a liniilor] GROUP BY [ coloane dupa care se face gruparea liniilor] ORDER BY [coloana/coloanele] [ASC/DESC]  LIMIT [nr de linii selectate];

CLAUZA 'WHERE' IN INTEROGARI DE SELECTIE

-- contine o EXPRESIE ce poate avea valoarea ADEVARAT sau FALS, pt fiecare linie in parte
-- mai departe sunt selectate numai liniile care produc valoarea ADEVARAT

EXPRESIA  se construieste folosind 

1) operatori de comparatie =,!= (sau <>), <,>,>=,<=, LIKE, NOT LIKE, REGEXP (sau RLIKE), NOT REGEXP, BETWEEN, IN, NOT IN, IS NULL,IS NOT NULL
2) Operatorii AND, OR, XOR,  NOT 
2) operatori aritmetici +,-,*,/
3) liste de numere sau siruri de caractere
4) paranteze
5) daca in clauza WHERE se folsoesc coloane din mai multe tabele atunci acestea sunt precedate de numele tabelelor din care provin (daca numele coloanelor apar in mai multe tabele) 


Pentru exemplele de mai jos vom considera tabelele:

drop database if exists lib7;
create database lib7;
use lib7;
create table clienti(
id_client int unsigned not null auto_increment primary key,
nume varchar(20) not null,
an_nastere int DEFAULT 1997,
greutate DOUBLE,
tel char(11),
data_inreg DATE  
  );
insert into clienti(nume, an_nastere, data_inreg) values
('ion',1990,'2019-8-23'),
('dan',1991,'2019-9-23'),
('Dan',1993,'2019-10-23'),
('Marian',1993,'2019-11-23');

insert into clienti(nume, an_nastere, data_inreg,greutate,tel) values
('Maria',1994,'2019-10-25',50.3,'0724-213458'),
('Dana',1996,'2019-10-26',47.2,'0734-213453'),
('Lia',1997,'2019-10-27',65.5, '0744-213456');


create table comenzi(
id_comanda int unsigned not null auto_increment primary key,
id_client int unsigned not null,
valoare  double DEFAULT 0.0,
data_comanda DATE,
 foreign key(id_client) references clienti(id_client)
on update cascade on delete cascade  
  );
insert into comenzi(id_client,valoare, data_comanda) values
(1,11.0,'2019-11-23'),
(1,1.0,'2019-11-24'),
(2,2.0,'2019-11-24');


Ex 1) Selectam toti clientii care nu sunt nascuti in 1990
select * from clienti where an_nastere !=1990;


sau folosind operator NOT
select * from clienti where NOT(an_nastere =1990);


sau folosind operatorul OR
select * from clienti where an_nastere<1990 OR an_nastere>1990;


Ex 2) selectam toti clientii cu greutate >60kg si nascuti strict dupa 1990

select * from clienti where (greutate >60) AND (an_nastere >1990);


Operatorul BETWEEN

Ex 3)
Selectam clientii nascuti intre 1993 si 1999  (se vor include si anii 1993 si 1999)
select * from clienti where an_nastere BETWEEN 1993 AND 1999;

Intervale pentru siruri de caractere de aceeasi lungime, se ordoneaza in functie de 
ordinea caracterelor in character set.

Ex 4) select * from clienti where tel between '0724-213456' and '0734-213456';  


Operatorul IN 
-- se verifica daca o valoare ce provine dintr-un camp sau o combinatie de campuri printr-o anumita operatie
apartine unei liste de valori (ce pot fi numere, siruri de caractere, date temporale, etc

Ex 5) Selectam toti clientii nascuti in anii 1998, 1991, 1994, 1997
select * from clienti where an_nastere IN (1998,1991, 1994,1997);


--lista poate fi ea insasi un rezultat al unei alte interogari

Ex 6) 
Selectam toti clientii care au plasat cel putin o comanda
select * from clienti where id_client IN (select id_client from comenzi);

Operatorul NOT IN 
-- pt a verifica daca o anumita valoare a unui camp nu apartine unei liste de valori.

Ex 7) Selectam toti clientii care nu au plasat nicio comanda
select * from clienti where id_client NOT IN (select id_client from comenzi);

Operatorii LIKE, NOT LIKE, REGEXP (sau RLIKE), NOT REGEXP se folosesc exact in acelasi mod ca la 
constructia regulilor de validare din lectiile trecute.

Ex 8) Afisati toti clientii al caror nume contine a si este format numai din litere
select * from clienti where nume RLIKE '^[a-z]*a[a-z]*$';


Ex 9) Afisati toti clientii al caror nume incepe cu D si e format numai din litere
select * from clienti where nume RLIKE '^D[a-z]*$';

Ex 10) Afisati toti clientii al caror nume contine secventa 'an'
si e format numai din litere

select * from clienti where nume RLIKE '^[a-z]*an[a-z]*$';

Ex 10') Afisati toti clientii cu nume  din 3 litere, a doua fiind 'a''
select * from clienti where nume RLIKE '^[a-z]a[a-z]$';

=======================================================
pt cautari case sensitive se poate folosi REGEXP BINARY precum in laboratorul anterior

selectati toti clientii al caror nume incepe cu D mare  si e format numai din litere
select * from clienti where nume REGEXP BINARY '^D[a-zA-Z]*$';

========================================================


NULL semnifica faptul ca in campul respectiv nu e stocata nicio data.
Testarea valorii nule se face cu operatorii IS NULL, IS NOT NULL

Ex 11) selectam toti clientii a caror greutate nu a fost introdusa in tabel
select * from clienti where greutate IS NULL;

Ex 12) selectam toti clientii care au telefonul introdus in tabel
select * from clienti where tel IS NOT NULL;


EXPRESIA DE AFISARE


SELECT [expresie de afisare] FROM [tabele] ON [clauza de asociere a tabelelor] WHERE [conditie de filtrare a liniilor] GROUP BY [ coloane dupa care se face gruparea liniilor] ORDER BY [ASC/DESC]  LIMIT [nr de linii selectate];



contine campurile (sau functii evaluate in aceste campuri) ce se doreste a fi afisate. Campurile sunt separate de virgula iar daca selectia provine din mai multe tabele atunci numele campului e precedat de 'nume_tabel.'. Daca numele campului nu se repeta in mai multe tabele in cares e face selectia atunci numele tabelului se poate omite.

Exemple:

#selectam tot continutul tabelului clienti
select * from clienti;

#selectam numai campul nume din tabelul clienti
select nume from clienti;

# selectam numele si id_client din tabelul clienti.

select nume, id_client from clienti;


#selectam tot continutul tabelului comenzi impreuna cu numele clientilor care au dat comenzile (atentia e pe sintaxa pentru afisare, restul se discuta mai tarziu)


select clienti.nume, comenzi.* from clienti join comenzi on clienti.id_client=comenzi.id_client;

# selectam id_comanda, numele celui care a dat-o si valoarea.  (atentia e pe sintaxa pentru afisare, restul se discuta mai tarziu)
select clienti.nume, comenzi.id_comanda, comenzi.valoare from clienti join comenzi on clienti.id_client=comenzi.id_client;

#se pot aplica functii acestor campuri.
#Afisam fiecare client impreuna cu anul in care s-a inregistrat.

select nume, year(data_inreg) from clienti; 

# se pot face operatii cu coloane 

select ascii(mid(nume,1,1))+year(data_inreg) from clienti;


Observati ca acea coloana afisata are un nume complicat, Pentru a-i da un nume se poate folosi un ALIAS

select ascii(mid(nume,1,1))+year(data_inreg) AS NUME from clienti;

sau

select ascii(mid(nume,1,1))+year(data_inreg)  NUME from clienti;

=====================================================================================================


create table t1(x1 int,x2 int);
create table t2(y1 int,y2 int, y3 int);


insert into t1  values(1,1);
insert into t1  values(2,2);


insert into t2  values(3,3,3);
insert into t2  values(4,4,4);