#katsotaan mitä tauluja on tietokannassa friends
show tables FROM friends;

#asetetaan friends tietokanta "aktiiviseksi"
use friends;
#nyt tietokannan taulut voidaan tarkistaa komennolla
show tables;

#millainen on taulun phone rakenne
describe phone;

#mitä dataa on taulussa friend
SELECT * FROM friend;

#edellä * antaa kaikki sarakkeet
#tulostetaan sarakkeet name ja street_address
SELECT name, street_address FROM friend;

#mitä katuosoitteita on friend taulussa
SELECT street_address FROM friend;
#sama mutta kukin arvo vain kerran
SELECT DISTINCT street_address FROM friend;

#mitä postinumero taulussa on?
SELECT * from postnumber;

INSERT INTO postnumber VALUES('21330','Paattinen');
INSERT INTO postnumber VALUES('20320','Turku');
INSERT INTO postnumber VALUES('20750','Turku');

INSERT INTO postnumber VALUES('33200','Tampere');
INSERT INTO postnumber VALUES('33820','Tampere');

#Mitä postipaikkoja postnumber taulussa on?
SELECT DISTINCT post_place FROM postnumber;
#sama mutta aakkosjärjestyksessä
SELECT DISTINCT post_place FROM postnumber ORDER BY post_place;
#sama kuin edellä mutta "vähenevään" järjestykseen
SELECT DISTINCT post_place FROM postnumber ORDER BY post_place DESC;

#tulostetaan kaikki Turun postinumerot
SELECT postal_code, post_place FROM postnumber WHERE post_place='Turku';
#kaikki muut paitsi ne joissa postipaikka on Turku
SELECT postal_code, post_place FROM postnumber WHERE NOT post_place='Turku';
#seuraava toimii myös ainakin MySQL:ssä, mutta NOT versio on SQL standardin mukainen
SELECT postal_code, post_place FROM postnumber WHERE post_place != 'Turku';

#tulostetaan kaikki T-kirjaimella alkavat postipaikat
SELECT post_place FROM postnumber WHERE post_place LIKE 'T%';

SELECT * FROM postnumber;
DELETE FROM postnumber WHERE postal_code IS NULL;
INSERT INTO postnumber VALUES('04380','Tuusula');

#tulostetaan kaikki 'Tu' alkuiset postipaikat
SELECT post_place FROM postnumber WHERE post_place LIKE 'Tu%';

INSERT INTO postnumber VALUES('70120','Kuopio');

#tulostetaan postipaikat joiden toinen kirjain on u 
SELECT post_place FROM postnumber WHERE post_place LIKE '_u%';
#tulostetaan postipaikat joiden nimessä on kirjain p 
SELECT post_place FROM postnumber WHERE post_place LIKE '%p%';

#Lisätään kavereita
SELECT * FROM friend;
INSERT INTO friend(name,birthday,street_address,postal_code)
	VALUES('Jussi','1972-12-01','Hallituskatu 7','20320');
INSERT INTO friend(name,birthday,street_address,postal_code)
	VALUES('Liisa','1978-12-15','Hallituskatu 68','20320');

#Tulostetaan kaverien nimet ja osoitteet (katuosoite, postinumero, postipaikka)
#friend taulusta saadaan muut mutta ei postipaikkaa
SELECT name, street_address,postal_code 
FROM friend;
#nyt tarvitaan liitos, koska haetaan dataa kahdesta taulusta
SELECT name, street_address,postnumber.postal_code, post_place 
FROM friend INNER JOIN postnumber ON friend.postal_code = postnumber.postal_code;

#tulostetaan koko osoite yhteen kenttään käyttäen CONCAT funktiota
SELECT name, CONCAT(street_address,postnumber.postal_code, post_place) 
FROM friend INNER JOIN postnumber ON friend.postal_code = postnumber.postal_code;
#lisätään välilyönnit
SELECT name, CONCAT(street_address," ",postnumber.postal_code," ", post_place) 
FROM friend INNER JOIN postnumber ON friend.postal_code = postnumber.postal_code;
#muokataan sarakeotsikko
SELECT name, CONCAT(street_address," ",postnumber.postal_code," ", post_place) AS 'address'
FROM friend INNER JOIN postnumber ON friend.postal_code = postnumber.postal_code;
#suomenkieliset sarakeotsikot
SELECT name AS 'Nimi', CONCAT(street_address," ",postnumber.postal_code," ", post_place) AS 'Osoite'
FROM friend INNER JOIN postnumber ON friend.postal_code = postnumber.postal_code;

#Lisätään syntymäaika
SELECT name AS 'Nimi', CONCAT(street_address," ",postnumber.postal_code," ", post_place) AS 'Osoite',birthday
FROM friend INNER JOIN postnumber ON friend.postal_code = postnumber.postal_code;
#esitetään syntymäaika "suomalaisessa" muodossa
SELECT name AS 'Nimi', CONCAT(street_address," ",postnumber.postal_code," ", post_place) AS 'Osoite',
DATE_FORMAT(birthday,"%d.%m.%Y") AS 'syntymäaika'
FROM friend INNER JOIN postnumber ON friend.postal_code = postnumber.postal_code;
#hakusanaksi mysql date format

#lisätään edelliseen puhelinnumero
#tarvitaan lisäksi phone taulu ja sillä on yhteinen kenttä friend_id friend-taulun kanssa
SELECT name AS 'Nimi', CONCAT(street_address," ",postnumber.postal_code," ", post_place) AS 'Osoite',
DATE_FORMAT(birthday,"%d.%m.%Y") AS 'syntymäaika', phone_number AS 'puhelinnumero'
FROM friend INNER JOIN postnumber ON friend.postal_code = postnumber.postal_code
	INNER JOIN phone ON friend.friend_id = phone.friend_id;
    
#tulostetaan myös ne kaverit, joilla ei ole puhelinta
#eli siis phone taulussa ei ole kaverin friend_id arvoa
SELECT name AS 'Nimi', CONCAT(street_address," ",postnumber.postal_code," ", post_place) AS 'Osoite',
DATE_FORMAT(birthday,"%d.%m.%Y") AS 'syntymäaika', phone_number AS 'puhelinnumero'
FROM friend INNER JOIN postnumber ON friend.postal_code = postnumber.postal_code
	LEFT JOIN phone ON friend.friend_id = phone.friend_id;
    
    
#tulostetaan nimi ja puhelinnumero
SELECT name, phone_number
FROM friend INNER JOIN phone ON friend.friend_id = phone.friend_id;
#tulostetaan myös ne kaverit joilla ei ole puhelinta
SELECT name, phone_number
FROM friend LEFT JOIN phone ON friend.friend_id = phone.friend_id;
#sama tulos saadaan myös näin
SELECT name, phone_number
FROM phone RIGHT JOIN friend ON friend.friend_id = phone.friend_id;