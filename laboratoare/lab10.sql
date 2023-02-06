
FUNCTII PENTRU MANIPULAREA DATELOR

1) Afisati tabelul CARTI in formatul:

ID CARTE: (id_carte); titlu carte: (titlu); pret carte: (pret)

select id_carte as "ID CARTE",titlu as "titlu carte",pret as "pret carte" from carti;

2) Afisati campul pret din tabelul carti cu 2 zecimale exacte.

select format(pret,2) from carti;

3) Afisati campul pret din tabelul carticu valoarea lui rotunjita la 2 zecimale.

select round(pret,2) from carti;

4) Afisati tabelul clienti cu 3 zile adunate la campul data.

select date_add(data_inreg, interval 3 day) from clienti;

5) Afisati diferenta intre data curenta si data stocata in tabelul comenzi.

select datediff(now(),data) as "diferenta dintre data curenta si data din tabelul comenzi" from comenzi;


Interogari UPDATE,DELETE, ALTER
--------------------------------------------------
1) mariti pretul tuturor cartilor cu o unitate.

update carti set pret=pret+1;

2) Mariti pretul cartii cu id '1234' cu 2 ron.

update carti set pret=pret+2 where id_carte='1234';

3) Scadeti cu o unitate pretul cartilor ce nu au fost cumparate niciodata.

update carti set pret=pret-1 where id_carte not in (select id_carte from comenzi);

4) Creati in tabelul carti o coloana numita pret_nou de tip nr real.

alter table carti add pret_nou float;

5) Copiati datele din coloana pret in coloana pret_nou.

update carti set pret_nou=pret;

6) Modificati tipul coloanei titlu din carti pentru ca sa fie de tip varchar(50).

alter table carti modify titlu varchar(50);

7) Redenumiti coloana pret_nou cu numele pret_nou1.

update carti set pret_nou1=pret_nou;

8) Stergeti declaratia de cheia externa id_client din tabelul comenzi.

alter table comenzi drop foreign key id_client;

Fie tabelul test
create table test(id int not null primary key, a1 int);


9) Creati o coloana noua numita id1 de tip integer in tabelul test apoi mutati cheia primara din tabel pe id1.

create table test(id1 int not null primary key, a1 int);
alter table test drop primary key;
alter table test add primary key(id1);


10) Stergeti coloana pret_nou creata anterior in tabelul carti. 

alter table carti drop pret_nou;

11) Stergeti comanda cu id 1 precum.

delete from comenzi where id_comanda='1';

12) Stergeti clientul cu id_client='1235'.

delete from clienti where id_client='1235';