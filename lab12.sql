



1)  Calculati fara mysql  rezultatul final al urmatoarelor interogari apoi verificati raspunsul.
   set autocommit=1; 
   update carti set pret=1 where id_carte='1234';
   set autocommit=0;
    update carti set pret=2 where id_carte='1234';
   commit;     
   select pret from carti where id_carte='1234';

pret=2

2)  Calculati fara mysql  rezultatul final al urmatoarelor interogari apoi verificati raspunsul.
   set autocommit=1; 
    update carti set pret=1 where id_carte='1234';
   set autocommit=0;
   update carti set pret=2 where id_carte='1234';
   rollback;     
   select pret from carti where id_carte='1234';

pret=1

3)  Calculati fara mysql  rezultatul final al urmatoarelor interogari apoi verificati raspunsul.
   set autocommit=1; 
    update carti set pret=1 where id_carte='1234';
   set autocommit=0;
   update carti set pret=2 where id_carte='1234';
   update carti set pret=3 where id_carte='1234';
   rollback;     
   select pret from carti where id_carte='1234';

pret=1


4) set autocommit=1; 
    update carti set pret=1 where id_carte='1234';
   set autocommit=0;
    update carti set pret=3 where id_carte='1234';
   select pret from carti where id_carte='1234';

pret=3 (local)
pret=1 (global, daca nu se da commit)

5) 
   set autocommit=1;
   start transaction;
    update carti set pret=1 where id_carte='1234';
    commit;
     update carti set pret=3 where id_carte='1234';
    rollback;
    select pret from carti where id_carte='1234';

pret=3

6)  set autocommit=1; 
    update carti set pret=1 where id_carte='1234';
    start transaction;
     update carti set pret=2 where id_carte='1234';
    rollback;
   update carti set pret=3 where id_carte='1234';
    rollback;
     select pret from carti where id_carte='1234';


pret=3


SISTEMUL DE PRIVILEGII MYSQL



1) creati un utilizator cu numele dvs de familie care se va loga de la ip-ul
localhost

create user "constantin"@"localhost" identified by alex;

2) iesiti si conectati-va in contul nou creat.

¯\_(ツ)_/¯

3) iesiti, apoi din postura de admin schimbati parola userului creat, apoi iesiti si va conectati iar pe contul acelui user cu noua parola.

SET PASSWORD FOR "constantin"@"localhost" = PASSWORD("const42");

4) dati dreptul de
 select,  update, alter, create, delete, drop in baza libraria (baza care stocheaza tabelele clienti, carti, comenzi, carti_comandate).

grant select,  update, alter, create, delete, drop on l7_constantin_alexandru.* to "constantin"@"localhost";
flush privileges;
5) vizualizati drepturile acestui utilizator

show grants for "constantin"@"localhost";

6) iesiti din cont, conectati-va pe contul utilizatorului nou creat, verificati ca el nu poate insera in baza.

¯\_(ツ)_/¯

7) ca admin, visualizati toti utilizatorii din sistemul dvs pentru a vedea si utilizatorul nou creat

use mysql;
select User from user;

8) retrageti toate privilegiile acordate utilizatorului nou creat, verificati ca nu mai are drepturi conectandu-va pe contul lui.

revoke all on l7_constantin_alexandru from "constantin"@"localhost";
flush privileges;

9) stergeti utilizatorul nou creat.

drop user "constantin"@"localhost";



