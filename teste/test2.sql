





1. Se da baza postata in laboratorul 7. Scrieti o interogare care va sterge din tabelul clienti  toti clientii al caror telefon contine cifra 3.

1. delete from clienti where tel regexp "3";

2. Fie baza de date din laboratorul 7. Modificati tipul coloanei oras  din tabelul clienti pentru ca sa fie de tip varchar(50).

2. alter table clienti modify oras varchar(50);

3. Se da baza de date postata in laboratorul 7. Scrieti o interogare de tip UPDATE pentru ca data inregistrarii clientului cu cnp ‘1234’ sa devina 23 Noiembrie 2020.

3.UPDATE clienti SET data_inreg="2020-11-23" WHERE cnp="1234";

4. Se da baza de date postata in laboratorul 7. Sa se construiasca o procedura care sa stearga din tabelul comenzi toate comenzile cu valoarea mai mare strict ca o valoare precizata. In procedura se introduce acea valoare iar apoi toate comenzile de valoare mai mare vor fi sterse din tabelul comenzi.
4.
drop procedure if exists ex4;
delimiter  //
create procedure ex4(in val_data double)
begin

delete from comenzi where valoare > val_data;

end
//
delimiter ;

rulare:   call ex4(100);



5. Se da baza de date postata in laboratorul 7. Sa se construiasca o procedura care sa afiseze 'DA' daca un client de cnp introdus locuieste in GALATI si ‘NU’ altfel. In procedura se va introduce cnp-ul clientului.


5.
drop procedure if exists ex5;
delimiter  //
create procedure ex5(in cnp_dat char(13))
begin
declare rezultat char(5);
declare oras_gasit char(50);
declare c cursor for select oras from clienti where cnp=cnp_dat;

open c;
fetch c into oras_gasit;
if oras_gasit = "Galati" then
    set rezultat="da";
    ELSE 
    set rezultat="nu";
end if;
close c;
select rezultat;
end;
//
delimiter ;

rulare: call ex5("1234");

6. Se da tabelul T cu structura

mysql> desc T;
+-------+---------+------+-----+---------+-------+
| Field | Type    | Null | Key | Default | Extra |
+-------+---------+------+-----+---------+-------+
| c1    | int(11) | NO   |     | NULL    |       |
| c2    | int(11) | NO   |     | NULL    |       |
+-------+---------+------+-----+---------+-------+

T are 100000 de linii, pe coloana c1 de sus in jos are numerele 0,1,0 ,1 ...0,1 iar pe coloana c2 de sus in jos are numerele 1,-1,1,-1,1,-1,...,1,-1.


Fie procedura

drop procedure if exists p;
delimiter //
create procedure p(  )
begin
declare x int;
declare k int;
declare c cursor for select c1 from T;

open c;

set k=1;
while(k<1900)  do

fetch c into x;

if k=9 then
select x;
end if;

set k=k+1;
end while;
close c;
end
//
delimiter ;

Ce va afisa comanda de mai jos?

call p();

6.procedura va afisa 1

7. Se da tabelul T cu structura

mysql> desc T;
+-------+---------+------+-----+---------+-------+
| Field | Type    | Null | Key | Default | Extra |
+-------+---------+------+-----+---------+-------+
| c1    | int(11) | NO   |     | NULL    |       |
| c2    | int(11) | NO   |     | NULL    |       |
+-------+---------+------+-----+---------+-------+

T are 50000 de linii, pe coloana c1 are numai 0 iar pe coloana c2  are de sus in jos 1,2,1,2...,1,2.

Explicati efectul fiecarei comenzi de mai jos si precizati numarul care se afiseaza la final.



7.    set autocommit=1; --seteaza autocommit-ul la 1, adica fiecare linie va fi salvata imediat dupa rulare
    update T set c1=2 where c2=1;--updateaza tabelul T, pe coloana c1 sa fie egal cu 2, acolo unde c2 este egal cu 1
    start transaction; --seteaza autocommit-ul la 0, pana la primul commit sau rollback
    update T set c1=3 where c2=1;--updateaza tabelul T, pe coloana c1 sa fie egal cu 3, acolo unde c2 este egal cu 1
    rollback; --face ca tot ce s-a facut pana acum in transaction sa nu fie salvat si sa se revina la valorile initiale, autocomiit=1(pt ca asa era inainte)
    update T set c1=4 where c2=1;-- updateaza tabelul T, pe coloana c1 sa fie egal cu 4, acolo unde c2 este egal cu 1
    rollback;--nu are efect pt ca autocommit=1
     select sum(c1) from T where c2=1; --selecteaza sumei coloanei c1 din tabelul t, de pe liniile unde c2=1

va afisa 4*5000/2 = 10000

8.  ca admin retrageti dreptul de insert in baza libraria  utilizatorului Popa care se conecteaza de la IP 127.0.0.1

8.revoke insert on libraria.* from "Popa"@"127.0.0.1";

9. ca admin listati toate privilegiile utilizatorului Popa care se conecteaza de la IP 127.0.0.1

9. show grants for "Popa"@"127.0.0.1";