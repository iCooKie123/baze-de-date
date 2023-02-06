PROCEDURI STOCATE
---------------------------------------------
1)Construiti o procedura stocata pentru introducere de noi carti dupa sablonul 
insereaza(id, titlu, autor, pret)

delimiter  //
create procedure insereaza(in id_carte char(13), in titlu varchar(50), in autor varchar(50), in pret double)
begin
insert into carti values(id_carte, titlu, autor, pret);
end
//
delimiter ;

2) construiti o procedura stocata care sa listeze toate cartile.
dupa sablonul
listeaza()

delimiter  //
create procedure listeaza()
begin
select * from carti;
end
//
delimiter ;


3)construiti o procedura stocata care sa incrementeze pretul cartilor cu o valoare data
updateaza (valoare)

delimiter //
create procedure updateaza(in val double)
begin
update carti set pret=pret+val;
end
//
delimiter ;

4)construiti o procedura stocata care sa scada pretul cartilor cu un procent dat.
descreste_pret(procent)        
procentul e introdus sub forma  descreste_pret(0.25)  inseamna ca se va scadea pretul cu 25%.   

delimiter //
create procedure descreste_pret(in procent double)
begin
update carti set pret=pret*(1-procent);
end
//
delimiter ;


5) construiti o procedura stocata care sa afiseze pretul unei carti dupa id-ul ei.
afiseaza(idcarte)

DELIMITER //
CREATE PROCEDURE afiseaza(in id_carte char(13))
BEGIN
SELECT pret FROM carti WHERE id=id_carte;
END
//
DELIMITER ;


6) construiti o procedura stocata care sa permute pretul a doua carti date, dupa id-ul lor.
permuta(id1,id2)

delimiter //
create procedure permuta(in id1 char(13), in id2 char(13))
begin
declare pret1 double;
declare pret2 double;
select pret into pret1 from carti where id=id1;
select pret into pret2 from carti where id=id2;
update carti set pret=pret2 where id=id1;
update carti set pret=pret1 where id=id2;
end
//
delimiter ;


7) construiti o procedura stocata care sa stearga o carte care n-a fost vanduta niciodata.
sterge(idcarte)

delimiter //
create procedure sterge(in id_carte char(13))
begin
delete from carti where id=id_carte and id not in (select id_carte from comenzi);
end
//
delimiter ;


8) Clasificati clientii in 3 categorii dupa valoarea totala a vanzarilor fiecaruia.
Cei cu valoare peste 11 sunt in categ1, intre 11 si 8 sunt in categ2, sub 8 in categ 3.
afiseaza_categ(cnp) ar trebui sa afiseze in ce categorie e clientul cu cnp-ul introdus.

delimiter //
create procedure afiseaza_categ(in cnp_cl char(13))
begin
declare val double;
select sum(pret) into val from carti, comenzi where carti.id=comenzi.id_carte and cnp=cnp_cl;
if val>11 then
select 'categ1';
elseif val>8 then
select 'categ2';
else
select 'categ3';
end if;
end
//
delimiter ;



9) Scrieti o procedura stocata care sa afiseze  'DA' daca titlul unei carti de id dat contine litera A
si 'NU' altfel.
afiseaza_carte(idcarte)

delimiter //
create procedure afiseaza_carte(in idcarte char(13))
begin
if (select titlu from carti where id_carte=idcarte) rlike 'A' then
select 'DA';
else
select 'NU';
end if;
end
//
delimiter ;



10) Gasiti comanda de valoare cea mai mare folosind cursori. Folositi o bucla while.

drop procedure if exists gasire_max;
delimiter  //
create procedure gasire_max()
begin

declare pret_curent double;
declare pret_max double default 0.0;
declare nr_linii int;
declare k int;


declare c cursor for select valoare from comenzi;

select count(*) into nr_linii from comenzi;
set k=1;

open c;

while(k<=nr_linii)  do

fetch c into pret_curent;

 if pret_curent>pret_max then 
    set pret_max=pret_curent;
  end if;

set k=k+1;
end while;


close c;

select pret_max;

 
end
//
delimiter ;

11) Refaceti 10) folosind o bucla loop.

drop procedure if exists gasire_max;
delimiter  //
create procedure gasire_max()
begin

declare pret_curent double;
declare pret_max double default 0.0;
declare nr_linii int;
declare k int;

declare c cursor for select valoare from comenzi;

select count(*) into nr_linii from comenzi;
set k=1;

open c;

iter: loop

fetch c into pret_curent;

 if pret_curent>pret_max then 
    set pret_max=pret_curent;
  end if;

set k=k+1;

if k>nr_linii then
leave iter;
end if;
end loop;
select pret_max;


end
//
delimiter ;



