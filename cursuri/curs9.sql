


SELECT [expresie de afisare] FROM [tabele] ON [clauza de asociere a tabelelor] WHERE [conditie de filtrare a liniilor] GROUP BY [ coloane dupa care se face gruparea liniilor] HAVING [conditie] ORDER BY [coloana/coloanele]    [ASC/DESC]  LIMIT [nr de linii selectate];


CLAUZA GROUP BY

SE FOLOSESTE PT A GRUPA LINIILE DINTR-UN TABEL DUPA UN IDENTIFICAT0R DINTR-O COLOANA SAU MAI MULTE DUPA CARE SE POATE APLICA O 
FUNCTIE MATEMATICA DE COMASARE( MIN, MAX, COUNT, SUM,. AVG,...) PE FIECARE GRUPO IN PARTE.


GRUPARE DUPA O COLOANA
Ex1
Afisam nr de COMENZI ALE FIECARUI client in parte
select cnp, count(*) from comenzi group by cnp;
=============================================================================================

ADAUGARE DATE LA TABEL OBTINUT PRIN GRUPARE DATE.

Ex1') Adaugam si numele


 select clienti.cnp, count(*),nume   from clienti join comenzi on clienti.cnp=comenzi.cnp group by clienti.cnp;




Alta solutie:



Notam tabelul de mai sus cu t, il asociem cu tabelul clienti pe baza cnp-ului, adaugand apoi numele clientilor din tabnelul clienti.


select c.nume, t.* from clienti as c join (select cnp, count(*) as nr_comenzi from comenzi  group by cnp) as t on t.cnp=c.cnp;

==============================================================================================

INCA UN EXEMPLU DE GRUPARE

Ex2
Afisam valoarea medie a comenzilor fiecarui client
select avg(valoare) from comenzi group by cnp;



==============================================================================================

SE POATE AFISA COLOANA DUPA CARE SE FACE GRUPAREA IMPREUNA CU DIFERITE VALORI ALE FUNCTIILOR DE COMASARE APLICATE PE ACESTE GRUPURI.

Ex3
Afisam valoarea medie si nr de comenzi pe fiecare client in parte
select cnp avg(valoare), count(*) from comenzi group by cnp;



==============================================================================================


CLAUZA HAVING  se poate folosi pentru a exclude anumite grupuri. este un fel de clauza where aplicata direct pe grupuri.

Ex4
Afisam valoarea medie si nr de comenzi pe fiecare client in parte dar numai pt acei clienti care
au mai mult de o comanda
select cnp, avg(valoare), count(*) from comenzi group by cnp having count(*)>1;




==============================================================================================

SE POATE FACE GRUPARE DUPA MAI MULTE COLOANE SIMULTAN.

Ex5
Afisam nr de carti cumparate pe fiecare client si fiecare carte in parte
select cnp, id_carte, sum(cantitate) from comenzi co join carti_comandate cm  on  co.id_comanda=cm.id_comanda group by co.cnp,cm.id_carte;

Ex6
Afisam nr de comenzi pe fiecare client in parte impreuna cu numele clientului (vedeti si ex1')
select c.nume, c.cnp, count(*) from clienti as c join comenzi as co on c.cnp=co.cnp group by c.nume, c.cnp;

==============================================================================================

APLICATIE:

Ex7
Afisam fiecare comanda impreuna cu valoarea ei calculata folosind numai datele din tabelele carti_cumparate si carti. 

select sum(ca.pret*cm.cantitate), cm.id_comanda from carti_cumparate cm join carti ca on cm.id_carte=ca.id_carte group by cm.id_comanda;









==============================================================================================

SE POATE GRUPA dupa valori procesate ale unei coloane


ex8
Afisam numarul de clienti inregistrati pe fiecare an in parte

select year(data_inreg),count(*) from clienti group by year(data_inreg);

=========================================================================

EXTRA:  UTILIZAREA CUVANTULUI CHEIE 'DISTINCT' PT A AFISA NUMAI VALORI DISTINCTE

Ex 9
Afisam nr de clienti care au cel putin o comanda. (AVETI IN VEDERE CA FUNCTIA COUNT  nu numara valorile nule)
select count( distinct cnp) FROM comenzi;

Ex 9. AVETI IN VEDERE CA FUNCTIA COUNT  nu numara valorile nule
select count(distinct tel) from clienti;

Ex10
Operatii cu campuri
SELECT MIN(cast(mid(cnp,1,1) as unsigned)+   cast(mid(cnp,2,1) as unsigned)) FROM clienti;




FUNCTII PT MANIPULAREA DATELOR



FUNCTII PENTRU SIRURI DE CARACTERE

Ex11
char(100)   returneaza caracterul care are codul ASCII 100

select char(100);

Ex12 Afisam numele clientilor in formatul:

Nume client: ION
Nume client: Maria etc

select concat('Nume client:', nume) from clienti;

Ex13 Afisam nr de caractere din fiecare nume de client
select length(nume) from clienti;


Ex14 Afisam primul caracter din fiecare nume de client
select left(nume,1) from clienti;

Ex15  Afisam toti clientii al caror nume incepe cu D sau cu d

select * from clienti where left(nume, 1)='D';

la fel ca
select * from clienti where left(nume, 1)='d';

Ex16  Pr a forta cautarea case-sensitive vom pune conditia ca
sa fie codurile ascii la fel

select * from clienti where ascii(left(nume, 1))=ascii('D');



Ex 17 Afisam prima aparitie a caracterului 'a' in 'Maria'
select position('a' in 'Maria');



Ex 18  Afisam prima aparitie a lui 'a' incepand cu al treilea caracter din 'Maria'
select locate('a','Maria',3);



Ex19 Compararea sirurilor de caractere cu strcmp

case insensitive
select strcmp('abc','def');
select strcmp('abc','abc');
select strcmp('abc','ABC');
select strcmp('def','abc');


comparatie case sensitive
select strcmp(binary 'abc',binary 'abc');
select strcmp(binary 'abc',binary 'ABC');


Ex 20 Inlocuim cd cu 67
select  insert('abcdefg', 3,2,'67');


FUNCTII PENTRU DATE NUMERICE

Ex21 trunchiere valoare  din tabelul programari la 2 zecimale exacte

select truncate(2.234,2);

Ex22  rotunjire valoare din tabelul programari la 2 zecimale

select round(2.234,2);
select round(2.235,2);



Ex23. partea intreaga 

select floor(2.23);

select floor(-2.23);

Ex24. Functia ceil(x) returneaza cel mai mic intreg care este mai mare sau egal cu nr real x.
select ceil(2.23);



FUNCTII PENTRU DATE TEMPORALE


Ex 25 Adunam 3 zile la data curenta. Care va fi data care rezulta?

select date_add(curdate(), interval 3 day) 

Ex 26 Adunam 30 minute la momentul curent

select date_add(curtime(), interval 30 minute) ;

Ex 27 Cate zile intre data de azi si 1 Noiembrie 2018?

select datediff(curdate(),'2018-11-1');  

=======================================================================================