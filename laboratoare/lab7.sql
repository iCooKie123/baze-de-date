Copy/paste din fisierul baza7.txt  in terminalul MySQL  pentru a crea baza 
l7  pe care vom lucra. 


CLAUZA WHERE

1) Listati toate cartile(id_carte, titlu, pret) cu pretul >1.0. 

select id_carte,titlu,pret from carti where pret>1.0;

2) Listati toate CARTILE(id_carte, titlu, pret) cu PRETUL intre intre 1.0 si 3.0

select id_carte,titlu,pret from carti where pret>1.0 and pret<3.0;

3) Listati toti clientii(nume, oras, data_inreg) inregistrati la data de 25 NOIEMBRIE, 2019.

select nume,oras,data_inreg from clienti where data_inreg='2019-11-25';


4) Listati toti clientii(nume, oras, data_inreg) inregistrati in anul 2016.

select nume,oras,data_inreg from clienti where year(data_inreg)=2016;

5) Listati toate CARTILE(id_carte, titlu, pret) al caror TITLU incepe cu litera L.

select id_carte,titlu,pret from carti where titlu rlike '^L';


6) Listati toate CARTILE(id_carte, titlu, pret) cu TITLU in multimea ('MATEMATICA','INFORMATICA')

select id_carte,titlu,pret from carti where titlu in ('MATEMATICA','INFORMATICA');

7) Listati toti clientii(cnp,nume, tel) care nu au specificat nr de telefon.

select cnp,nume,tel from clienti where tel is null;

8) Listati toti clientii(cnp,nume) al caror nume contine secventa 'na'.

select cnp,nume from clienti where nume rlike 'na';

9) Listati toate cartile(id_carte, titlu, autor) al caror titlu contine secventa 'mate'.

select id_carte,titlu,autor from carti where titlu rlike 'mate';

10) Listati toate cartile(id_carte, titlu) al caror titlu se termina cu 'a'.

select id_carte,titlu from carti where titlu rlike 'a$';

11) Listati toate cartile care nu au id_carte in multimea ('1234','1235').

select * from carti where id_carte not in ('1234','1235');

12) Listati toti clientii(cnp,nume) inregistrati intre 1-1-2014 si 20-12-2015.

select cnp,nume from clienti where data_inreg > '2014-01-01' and data_inreg< '2015-12-20';

sau 

select cnp,nume from clienti where data_inreg between '2014-01-01' and '2015-12-20';

13) Listati toti clientii(cnp, nume) al caror nume incepe cu D si  s-au inregistrat in 2015.

select cnp,nume from clienti where nume rlike '^D' and year(data_inreg)=2015;

14) Afisati toate cartile(titlu, pret) din baza scrise de Ionescu.

select titlu,pret from carti where autor='Ionescu';

15) Listati toti anii in care s-au inregistrat clientii din tabelul clienti.

select distinct year(data_inreg) from clienti;