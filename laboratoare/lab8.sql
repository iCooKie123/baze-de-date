Se va lucra pe baza din laboratorul 7.


SELECTARE DATE DIN MAI MULTE TABELE
INNER JOIN

1) Afisati toate comenzile impreuna cu numele clientilor care le-au facut.

select * from comenzi inner join clienti on comenzi.cnp=clienti.cnp;

2) Afisati toate cartile cumparate in cadrul comenzii cu id 2 impreuna cu titlul si pretul fiecareia.

select * from carti_comandate inner join carti on carti_comandate.id_carte=carti.id_carte where id_comanda=2;

3) Afisati toate cartile cumparate din tabelul carti_comandate impreuna cu titlul si pretul fiecareia. Se vor afisa o singura data folosind 
'select distinct'

select distinct carti_comandate.id_carte, carti.titlu, carti.pret from carti_comandate inner join carti on carti_comandate.id_carte=carti.id_carte;

INNER JOIN pe mai multe tabele

4) Afisati toate cartile cumparate de clientul cu cnp '1234'.

select titlu from carti_comandate inner join carti on carti_comandate.id_carte=carti.id_carte inner join comenzi on carti_comandate.id_comanda=comenzi.id_comanda where comenzi.cnp='1234';

5) Afisati toti clientii care au cumparat cartea cu id_carte ='1236'.

select nume from clienti inner join comenzi on clienti.cnp=comenzi.cnp inner join carti_comandate on comenzi.id_comanda=carti_comandate.id_comanda where carti_comandate.id_carte='1236';

LEFT JOIN


6) Afisati toti clientii care nu au dat nicio comanda niciodata.

select * from clienti left join comenzi on clienti.cnp=comenzi.cnp where comenzi.id_comanda is null;

7) Afisati toate cartile care n-au fost cumparate niciodata.

select * from carti left join carti_comandate on carti.id_carte=carti_comandate.id_carte where carti_comandate.id_carte is null;

NATURAL JOIN

8) Afisati toate comenzile impreuna cu numele clientilor care le-au dat.

select * from comenzi natural join clienti;

9) Afisati toate comenzile(id_comanda) impreuna cu cartile(titlu, id_carte) cumparate in cadrul lor. 

select id_comanda,carti.titlu,carti.id_carte from carti_comandate natural join carti;




CREATE .. SELECT

10) Creati un tabel care sa contina fiecare carte(id_ul ei) din carti_comandate impreuna cu  numele celui care a cumparat-o. Alegeti nume sugestive pt coloane.

-- select carti_comandate.id_carte as "id-ul cartii",clienti.nume as "nume client" from carti_comandate inner join comenzi on carti_comandate.id_comanda=comenzi.id_comanda inner join clienti on comenzi.cnp=clienti.cnp;

create table carti_comandate1 as select carti_comandate.id_carte as "id-ul cartii",clienti.nume as "nume client" from carti_comandate inner join comenzi on carti_comandate.id_comanda=comenzi.id_comanda inner join clienti on comenzi.cnp=clienti.cnp;

CREATE VIEW. Creati tabelele virtuale specificate.

11) Toate comenzile(id, cnp, valoare, data) impreuna cu numele clientului scris cu litere mari.

create view comenzi_clienti as select comenzi.id_comanda,comenzi.cnp,comenzi.valoare,comenzi.data,upper(clienti.nume) as "nume client" from comenzi inner join clienti on comenzi.cnp=clienti.cnp;

12) Toate cartile(id_carte, titlu, pret) din carti_cumparate impreuna cu id_comanda corespunzatoare.

create view carti_comenzi as select carti_comandate.id_carte,carti.titlu,carti.pret,carti_comandate.id_comanda from carti_comandate inner join carti on carti_comandate.id_carte=carti.id_carte;


UNION, UNION ALL

13) Selectati toti clientii(nume, id) care n-au dat nicio comanda
apoi selectati  toti clientii care au plasat cel putin o comanda,
apoi uniti cele 2 tabele cu UNION ALL.

select nume,cnp from clienti where cnp not in (select cnp from comenzi) 
union all 
select nume,cnp from clienti where cnp in (select cnp from comenzi);

14) Selectati toti clientii(cnp) din tabelul comenzi care n-au comenzi in 2019, apoi toti clientii(cnp) din clienti care n-au dat nicio comanda niciodata apoi faceti reuniunea cu UNION.  Acestia ar fi toti clientii care n-au comandat nimic in 2019.
 
select cnp from comenzi where year(data) != 2019
UNION
select cnp from clienti where cnp not in (select cnp from comenzi);


Sortari

15) Afisati toate comenzile din 2018 in ordinea descrescatoare a valorii lor.
 
select * from comenzi where year(data)=2018 order by valoare desc;

16) Afisati toti clientii in ordinea inversa a introducerii lor in tabelul clienti (ordonare descendenta dupa data_inreg). 

select * from clienti order by data_inreg desc;

Aliasuri

17) Afisati toate comenzile clientului cu cnp '1234' impreuna cu cartile(titlu, pret) aferente. Folositi alias. 

select comenzi.id_comanda as "id-ul comenzii",carti.titlu as "titlul cartii",carti.pret as "pretul cartii"
 from comenzi inner join carti_comandate on comenzi.id_comanda=carti_comandate.id_comanda
  inner join carti on carti_comandate.id_carte=carti.id_carte where comenzi.cnp='1234';


FUNCTII DE COMASARE


18) Afisati valoarea totala a comenzilor din 2019.

select sum(valoare) from comenzi where year(data)=2019;

19) Cati clienti sunt inregistrati in baza dvs?

select count(*) from clienti;

20) Cat costa cea mai ieftina carte din baza dvs?

select min(pret) from carti;

21) Se da un tabel T1 cu doua campuri c1 si c2, ambele de tip int, ce contine 10 linii (listate de sus in jos): 
4, 1
-1,2
4,1
-1,2
...
4,1
-1,2

si un tabel T2 doua campuri c2 si c3, ambele de tip int, ce contine 10 linii (listate de sus in jos): 
-1,3
1,1
-1,3
1,1
-1,3
1,1
...
-1,3
1,1

Ce numar returneaza interogarile de mai jos?

select sum(c1) from T1 join T2; 
select sum(c1) from T1 join T2 on T1.c2=T2.c2;
select sum(c1) from T1 join T2 on T1.c2=T2.c3;
select sum(c1) from T1 natural join T2;
select sum(c1) from T1 left join T2 on T1.c2=T2.c2;
select sum(c1) from T1 left join T2 on T1.c2=T2.c2 where T2.c3 is null;
select sum(c1) from T1 left join T2 on T1.c2=T2.c2 where T2.c3 is not null;
select sum(c3) from T1 right join T2 on T1.c2=T2.c2 where T1.c1 is null;
select sum(c3) from T1 left join T2 on T1.c2=T2.c2 where T1.c1 is not null;


Incercati sa deduceti raspunsul fara a rula, apoi verificati raspunsul obtinut construind cele 2 tabele si ruland aceste interogari.



 