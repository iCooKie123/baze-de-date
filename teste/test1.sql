1)Creati un tabel A1 cu campuri
a1 --> integer, camp obligatoriu, cheie primara
a2 --> sir de caractere de lungime maxim 10, camp obligatoriu
a3 --> date temporale (an/luna/zi), valoare default 21 Noiembrie 2020
a4 ---> sir de caractere de lungime variabila, maxim 20 caractere
a5 ---> integer


Creati un tabel A2 cu campuri
b1 --> sir de caractere de lungime maxim 10, camp obligatoriu
b2 --> integer, camp obligatoriu
a1 --> integer, camp obligatoriu, cheie externa legata de cheia primara a1 din tabelul A1
in acest tabel A2 stabiliti cheie primara compusa din b1,b2.

Dupa ce ati creat tabelele
inserati cate o linie in fiecare tabel.


Create table if not exists A1(

 a1 int NOT NULL,

 a2 varchar(10) NOT NULL,

 a3 date DEFAULT '2020-11-20',

 a4 varchar(20),

 a5 int,

 PRIMARY KEY(a1)

);



Create table A2(

b1 char(10) NOT NULL,

b2 int NOT NULL,

a1 int NOT NULL,

PRIMARY KEY(b1,b2),

FOREIGN KEY (a1)

REFERENCES A1(a1)

ON UPDATE CASCADE ON DELETE CASCADE


);

Insert into A2(a1,a2,a4,a5) VALUES(2,34,3,2);


Insert into A2(b1,b2,a1) VALUES('asdasasdsa',34,2);

2)Scrieti un CONSTRAINT (constrangere) de tip CHECK pentru ca intr-un tabel dat doua campuri c3, c4, ambele de tip integer, sa satisfaca:
sa fie permise numai numere c3 strict mai mari  ca c4 si strict mai mici ca 10.

check(c3 >4 and c4<10);

3)Scrieti un CONSTRAINT (constrangere) de tip CHECK pentru ca intr-un tabel dat un camp c2 de tip char(10) sa satisfaca:c2 sa contina exact 2 caractere


check(c2 like '__');

4) Scrieti un trigger care sa reactioneze BEFORE INSERT intr-un tabel dat T ce contine un camp c2 de tip char(10) si care sa permita inserarea de valori in tabel numai daca:
primul caracter al lui c2 este litera.


CREATE TRIGGER ex4 BEFORE INSERT ON T

 FOR EACH ROW

 BEGIN



	IF (if(  ascii(mid(NEW.c2,1,1)) <65 || ascii(mid(NEW.c2,1,1)) >122 || (ascii(mid(NEW.c2,1,1)) >90 && ascii(mid(NEW.c2,1,1)) <97 )))

	

	THEN

		SIGNAL SQLSTATE '45000'

                    SET MESSAGE_TEXT = 'numele trebuie sa inceapa numai cu litera';

	END IF;



 END;

//

DELIMITER ;



5)sa contina un spatiu liber exact o data

select str regexp " {1}";

6) sa contina numai cifre sau cel mult un _ , iar acesta, daca apare, trebuie sa nu fie in capete.

select str regexp "^[0-9]*\\_?[0-9]*$";

7)sa contina numai litere din multimea {a,b, A,B} si de lungime maxim 5.

select str regexp "^[ab]{0,5}$";

8)primul caracter e  din multimea {1,2,3}, iar apoi numai litere mari.

select str regexp binary "^[123][A-Z]*$";



9)) sa nu contina litere mari

select str regexp binary "^[^A-Z]*$";

10)sa inceapa cu A (mare sau mic) si sa contina B(mare sau mic).

select str regexp binary "^[aA][bB]$";

