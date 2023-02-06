
proceduri stocate se folosesc  pentru executarea  unui grup de interogari, procesarea outputului , filtrarea datelor la inserarea in tabele, mascarea inputului anumitor interogari, etc 


structura:

DELIMITER //
create procedure [nume proc]([in/out/inout] param1 tip_param1, [in/out/inout] param2 tip_param2, ...     )
begin
 
INSTRUCTIUNI

end
//
DELIMITER ;

parametrii pot fi IN ( PT A INTRODUCE O VALOARE IN PROCEDURA), OUT (pt a returna o valoare din procedura) INOUT (ambele).

Exemplu:


1)(AFISARE) Exemplu listare clienti

Se executa in terminal instructiunile de mai jos:


delimiter  //
create procedure listeaza()
begin
select * from clienti;
end
//
delimiter ;


apelul procedurii listeaza se face cu

call listeaza();





2)(FOLOSIRE PARAMETRI IN) Exemplu inserare clienti



drop procedure insereaza;
delimiter  //
create procedure insereaza(in cnp_cl char(13), in numele varchar(20), in telef varchar(20) ,in orasul varchar(20))
begin

insert into clienti(cnp,nume, tel, oras, data_inreg) values(cnp_cl, numele, telef, orasul, curdate());

end
//
delimiter ;




rulare:

call insereaza('2345','Andrei','1234','Cluj');


3)(FOLOSIRE PARAMETRI IN) Exemplu. Se incrementeaza valoare in tabelul comenzi cu valoare data.

delimiter  //
create procedure incrementeaza(in val double )
begin

update comenzi set valoare=valoare+val;

end
//
delimiter ;

rulare:
call incrementeaza(5.0);



4)(FOLOSIRE PARAMETRI OUT) Exemplu: Determinarea valorii totale a comenzilor din tabelul comenzi.
Totalul va fi stocat intr-o variabila ce poate fi afisata sau folosita in interiorul altei proceduri sau intr-un trigger.


delimiter  //
create procedure total_com(out total double)
begin

select sum(valoare) into total from comenzi;
 
end
//
delimiter ;

rulare:

call total_com(@tot);
select @tot;



5) (UTILIZARE VARIABILE LOCALE) 

Permutarea numelor clientilor cu cnp-uri '1234', '1235'.



drop procedure exemplu;
delimiter  //
create procedure permutare()
begin

declare nume_client1 varchar(20);
declare nume_client2  varchar(20);


select nume into nume_client1 from clienti where cnp='1234';
select nume into nume_client2 from clienti where cnp='1235';

update clienti set nume=nume_client2 where cnp='1234';
update clienti set nume=nume_client1 where cnp='1235';

end
//
delimiter ;



5'') Exemplu: stergere clienti dupa cnp

delimiter  //
create procedure stergere(in cnp_cl char(13))
begin

delete from clienti  where cnp=cnp_cl;

end
//
delimiter ;



6) Listarea tuturor procedurilor stocate in baze de date la care am acces

show procedure status;

6'') Se poate adauga cautare dupa nume

show procedure status where name like '%list%';


7) Afisarea commenzii  de creare a unei proceduri stocate

show create procedure listeaza;



8) Stergere procedura stocata


drop procedure listeaza;



9) bloc IF/ELSE/ELSEIF in procedura stocata

structura: 

if expr1    then instr1;
elseif expr2  then instr2;
else  instr
end if;

Cautam un client dupa cnp. Daca valoarea totala a comenzilor lui este >11 vom returna '>11', altfel returnam '<=11'


drop procedure if exists exemplu_if;
delimiter  //
create procedure exemplu_if(in cnp_cl char(13), out rezultat varchar(10))
begin
declare suma double;
select sum(valoare) into suma from comenzi where cnp=cnp_cl and cnp_cl in (select cnp from clienti); 

if suma>11 then
  set rezultat='>11';
else set rezultat='<=11';
end if;

select rezultat;

end
//
delimiter ;




10) Bloc CASE 

structura:

case 
when expr1  then  instr1
when expr2  then instr2 
.
.
when exprn  then instrn
else  expr  then instr
end case;


Cautam un client dupa cnp. Daca valoarea totala a comenzilor lui este >11 vom returna '>11', altfel returnam '<11'


drop procedure if exists exemplu_case;
delimiter  //
create procedure exemplu_case(in cnp_cl char(13), out rezultat varchar(10))
begin
declare suma double;
select sum(valoare) into suma from comenzi where cnp=cnp_cl and cnp_cl in (select cnp from clienti); 

case 
when suma>11 then
  set rezultat='>11';
else set rezultat='<=11';
end case;

select rezultat;

end
//
delimiter ;












11) Bucla while 

structura:

iter:while expr do

instructiuni


if(expr1) then
leave iter;
end

end while


Verificam daca numele clientului cu cnp dat contine un caracter dat.


drop procedure if exists exemplu_while;
delimiter  //
create procedure exemplu_while(in cnp_cl char(13), in caracter char, out rezultat varchar(10))
begin
declare nume_cl varchar(20);
declare k int;
set k=0;
set rezultat='nu contine';

select nume into nume_cl from clienti where cnp=cnp_cl; 

iter: while(k<length(nume_cl)) do
set k=k+1;

if(ascii(mid(nume_cl,k,1))=ascii(caracter)) then

set rezultat='contine';
leave iter;
end if;


end while;

select rezultat;

end
//
delimiter ;








12) Bucla loop 

structura:

iter: loop

instructiuni

if(expr) then
leave iter;
end

end loop



Verificam daca numele clientului cu cnp dat contine un caracter dat.


drop procedure if exists exemplu_loop;
delimiter  //
create procedure exemplu_loop(in cnp_cl char(13), in caracter char, out rezultat varchar(10))
begin
declare nume_cl varchar(20);
declare k int;
set k=0;
set rezultat='nu contine';

select nume into nume_cl from clienti where cnp=cnp_cl; 

iter: loop 
set k=k+1;

if(k>length(nume_cl)) then
leave iter; 
end if;

if(ascii(mid(nume_cl,k,1))=ascii(caracter)) then
set rezultat='contine';
leave iter;
end if;


end loop;

select rezultat;

end
//
delimiter ;





13) Iesirea din executia unei proceduri se face cu comanda 'leave'. iata cum intrerupem executia procedurii de la exemplul 5'


5') Exemplu: stergere clienti dupa cnp

delimiter  //
create procedure stergere1(in cnp_cl char(13))
p1:begin

leave p1;
delete from clienti  where cnp=cnp_cl;

end
//
delimiter ;








13) Intr-o procedura se poate analiza si un tabel rezultat dintr-o interogare. Liniile din tabelul rezultat se pot citi linie cu linie folosind cursori.
Exemplu. Sa afisam cartea de valoare cea mai mare din tabelul carti (daca sunt mai multe de valoare maxima se va afisa prima care apare in tabel pornind de la prima linie in jos).





drop procedure if exists gasire_carte;
delimiter  //
create procedure gasire_carte(out id char(13))
begin

declare pret_curent double;
declare pret_max double default 0.0;
declare id_curent char(13);
declare  id_max char(13);

declare nr_linii int;
declare k int;


declare c cursor for select id_carte, pret from carti;

select count(*) into nr_linii from lib7.carti;
set k=1;

open c;

while(k<=nr_linii)  do

fetch c into id_curent, pret_curent;

 if pret_curent>pret_max then 
    set pret_max=pret_curent;
    set id_max=id_curent;
  end if;


set k=k+1;
end while;


close c;

select id_max, pret_max;

set id=id_max;
 
end
//
delimiter ;





FUNCTII IN MySQL sunt asemanatoare cu procedurile, numai ca nu se specifica parametri in/out/inout, toti parametrii de input sunt IN si se returneaza o singura valoare. Blocurile if, case si buclele while, loop se folosesc similar.

--> nu poate folosi proceduri 
--> pot fi folosite in interiorul interogarilor SELECT
--> se pot folosi in interior numai interogari de tip select.


STRUCTURA:


delimiter //
create function [nume](param1 tip param1, param2 tip parama2,...) returns [tip data returnata] deterministic/nondeterministic
begin

instructiuni

return(valoare);
end


Exemplu:
========================================================
delimiter //
create function exemplu_f(x float) returns float deterministic
return x*0.1;
//
delimiter ;
=======================================================


Afisam toate functiile din baza.

show function status where db='l5';


==================================================================

exemplu clasificare studenti

create table studenti (cnp char(13) primary key, nume varchar(20), prenume varchar(20), nota smallint);
insert into studenti values
('1234', 'IONESCU','ION', 8),
('1235', 'DANESCU','DAN', 10),
('1236', 'DINU','MARIA', 6),
('1237', 'VASILE','DANA', 3),
('1238', 'VASILE','LIA', 9);


delimiter //
create function clasificare(nr_com int) 
returns varchar(20) 
deterministic
begin

declare clasif_cl varchar(20);
case
  when nr_com=10 then set clasif_cl='excelent';
  when nr_com=9 then set clasif_cl='foarte bine';
  when nr_com<9 and nr_com>6 then set clasif_cl='bine';
  when nr_com<7 and nr_com>4 then set clasif_cl='mediocru';
  else set clasif_cl='slab';
  end case;
return (clasif_cl);
   

end
//
delimiter ;

select nume, prenume, clasificare(nota) from studenti;

