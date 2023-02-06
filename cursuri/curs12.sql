

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

insa daca se doreste sa se revina la starea in care era baza  cand s-a executat
autocommit=0 

in loc de commit se va executa 

rollback;

In continuare, daca se va executa un set de instructiuni, 

efectul acestora e facut definitiv(stocat in baza) executand commit,
iar efectul acestora e anulat executand rollback




Pentru a reveni la modul autocommit=1 (adica executia oricarei interogari e ireversibila) se executa
set autocommit=1;

Pentru a vizualiza modul autocommit existent la un moment dat se executaset autocommit=0;














select @@autocommit;




Exemplu: 

set autocommit=1;
update clienti set nume='Dan' where id_client=1;
set autocommit=0;
update clienti set nume='Lia' where id_client=1;
select * from clienti where id_client=1;
rollback; # revenim la starea anterioara, adica starea in care era baza cand am executat set autocommit=0;
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










SISTEMUL DE PRIVILEGII MYSQL

La instalarea pachetului software MySQL se va crea un cont de administrator
care are drepturi depline pe platforma.
Acest administrator poate crea la randul lui alti utilizatori cu diferite drepturi pe platforma.



Pentru aceasta, mai intai login pe platforma

mysql -u root -p 

apoi

se introduce parola de admin.


1) Crearea altor utilizatori se poate face cu comanda 'CREATE USER'

EXEMPLU: 

create user 'popescu'@'localhost' identified by 'popescu';
flush privileges;


deci username este popescu, parola este popescu, el trebuie sa se conecteze local de la adresa localhost(sau 127.0.0.1) 

Daca in loc de 'localhost' scriem 'adr_IP' atunci utilizatorul popescu se poate conecta numai de la 'adr_IP'.



In 'adr_IP' se pot folosi si wildcarduri (precum cele folosite cand am utilizat operatorul like), spre exemplu specificatia 

'popescu'@'%' 

face ca utilizatorul popescu sa se poata conecta de la orice IP. Pentru mai multe detalii in ce priveste moduri mai sofisticate de specificare a IP-ului se poate consulta pe situl mysql.com pagina
https://dev.mysql.com/doc/mysql-security-excerpt/5.7/en/account-names.html 




Pentru a schimba parola utilizatorului 'popescu'@'localhost' 

SET PASSWORD FOR 'popescu'@'localhost' = PASSWORD('popescu1');



Pentru ca toate modificarile sa fie facute din acest moment (si nu de la urmatoarea pornire a serverului mysql) se executa

flush privileges;
 

la momentul asta nu are decat privilegiul USAGE, adica este inregistrat pe platforma dar 
nu poate lucra in sensul adevarat (adica sa creeze baze de date, sa le populeze, etc)



pentru a se conecta local la server, utilizatorul popescu va executa in terminal:

mysql -u popescu -p


iar daca se conecteaza remote(are nevoie sa instaleze pe computerul de pe care se conecteaza un client mysql)

mysql -u popescu -p -h 'ip-ul serverului de mysql'









2) Drepturile utilizatorilor

fiecare utilizator poate avea  diferite privilegii pe anumite baze de date, in functie de activitatea desfasurata in relatie cu bazele de date respective
(adica unii utilizatori au de pilda numai dreptul de a cauta in baza de date, altii dreptul de a cauta dar si 
de a insera, updatata, sterge, etc)


cateva din privilegiile pentru utilizatori obisnuiti sunt 

select
insert
update
alter
create
delete
drop

cateva privilegii mai puternice(pentru administratori)

process    vizualizarea proceselor in derulare 
reload      reincarcarea tabelelor cu privilegii, acordare si stergere de privilegii 
show databases
shutdown
super     -- permite intreruperea taskurilor celorlalti utilizatori  
create user  


doua privilegii speciale  

all   se acorda toate privilegiile
usage  nu se acorda niciun privilegiu


PRIVILEGIILE se acorda cu comanda 'grant' si se retrag cu comanda 'revoke'

exemplu de acordare de drepturi de administrator:

grant all on  *.*  to 'popescu'@'localhost'  with grant option;
flush privileges;

utilizatorul 'popescu' care se va loga de la adresa 'localhost' va avea toate privilegiile pe toate bazele de date
si va putea acorda mai departe aceste privilegii.

comanda

revoke all privileges, grant option from 'popescu'@'localhost';
flush privileges;

va retrage toate privilegiile acordate utilizatorului popescu

Pentru crearea unui utilizator obisnuit al bazei de date 'lib7'(presupunem ca ea exista deja) mai intai vom crea utilizatorul (cu dreptul USAGE, vezi mai sus)

create user 'popescu'@'localhost' identified by 'popescu';
flush privileges;


ulterior putem sa-i acordam anumite privilegii

grant select, insert, delete, update, create, drop, alter on lib7.* to 'popescu'@'localhost';
flush privileges;



daca vrem sa vizualizam toate privilegiile

show grants for 'popescu'@'localhost';


si, daca dorim, putem sa retragem din ele

revoke alter, drop on lib7.*  from  'popescu'@'localhost';
flush privileges;


sau putem sa retragem toate drepturile

revoke all on lib7.* from 'popescu'@'localhost';
flush privileges;



Toti utilizatorii sunt stocati in tabela  'user' din baza de date 'mysql'
in aceasta tabela exista un camp numit tot user
aceasta tabela poate fi vizualizata cu comanda

use mysql
describe user
 
ei se pot sterge cu comenzile obisnuite de baze de date, de pilda , daca dorim sa stergem 
utilizatorul popescu vom executa

drop user 'popescu'@'localhost'




 









