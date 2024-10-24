-- Création des tables de la base de données
DROP TABLE IF EXISTS Detail CASCADE;

DROP TABLE IF EXISTS Produit CASCADE;

DROP TABLE IF EXISTS Commande CASCADE;

DROP TABLE IF EXISTS Client CASCADE;

CREATE TABLE Client (
  NCli VARCHAR PRIMARY KEY,
  Nom VARCHAR,
  Adresse VARCHAR,
  Localite VARCHAR,
  Cat VARCHAR,
  Compte REAL
);

CREATE TABLE Commande (
  NCom INT PRIMARY KEY,
  NCli VARCHAR,
  DateCom DATE,
  FOREIGN KEY (NCli) REFERENCES Client (NCli) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Produit (
  NProd VARCHAR PRIMARY KEY,
  Libelle VARCHAR,
  Prix INT,
  QStock INT
);

CREATE TABLE Detail (
  NCom INT,
  NProd VARCHAR,
  QCom INT,
  PRIMARY KEY (NCom, NProd),
  FOREIGN KEY (NCom) REFERENCES Commande (NCom) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (NProd) REFERENCES Produit (NProd) ON UPDATE CASCADE ON DELETE CASCADE
);

---------------
-- INSERTION --
---------------
-- table client
-- DELETE FROM Client;
INSERT INTO
  Client
VALUES
  (
    'B062',
    'Badri',
    '72, r de la gare',
    'Rabat',
    'B2',
    3200
  ),
  ('B112', 'Hosni', '23, r Ward', 'Safi', 'C1', 1250),
  (
    'B332',
    'Hasbi',
    '1, 12 r jadida',
    'Marrakech',
    'B2',
    0
  ),
  (
    'B512',
    'Adib',
    '14, r borj',
    'Agadir',
    'B1',
    8700
  ),
  (
    'C003',
    'Adnane',
    '25, r farah',
    'Agadir',
    'B1',
    1700
  ),
  (
    'C123',
    'Kabori',
    '8, r Lafayette',
    'Kenitra',
    'C1',
    2300
  ),
  (
    'C400',
    'Fadel',
    '65, r citronier',
    'Safi',
    'B2',
    3500
  ),
  (
    'D063',
    'Adnane',
    '201, bvd des FAR',
    'Agadir',
    '',
    2250
  ),
  ('F010', 'Tahiri', '5, d daya', 'Safi', 'C1', 0),
  (
    'F011',
    'Nasser',
    '17, r grenade',
    'Agadir',
    'B2',
    0
  ),
  (
    'F040',
    'Naciri',
    '78, b du moulin',
    'Tanger',
    'C2',
    0
  ),
  ('K111', 'Haddi', '18, r Ahr', 'Oujda', 'B1', 720),
  ('K729', 'Nadir', '40, r Badis', 'Agadir', '', 0),
  (
    'L422',
    'Ali',
    'rô de fleurs',
    'Tit Mellil',
    'C1',
    0
  ),
  (
    'S127',
    'Ghamidi',
    '3, av des roses',
    'Tit Mellil',
    'C1',
    4580
  ),
  (
    'S712',
    'Naoumi',
    '14, ach des forêts',
    'Casablanca',
    'B1',
    0
  );

select
  *
from
  client;

-- Table Commande
-- DELETE FROM Commande;
INSERT INTO
  Commande
VALUES
  (30178, 'K111', '2017-12-21'),
  (30179, 'C400', '2017-12-22'),
  (30182, 'S127', '2017-12-23'),
  (30184, 'C400', '2017-12-23'),
  (30185, 'F011', '2018-01-02'),
  (30186, 'C400', '2018-01-02'),
  (30188, 'B512', '2018-01-03');

select
  *
from
  commande;

-- Table Produit
-- DELETE FROM Produit;
INSERT INTO
  Produit
VALUES
  ('BP156', 'Bur.PC 150*60', 1500, 145),
  ('BP26', 'Bur.PC 300*60', 1060, 2690),
  ('BC15156', 'Bur.Coin 150*150*60', 2500, 1450),
  ('CF', 'Chais.Faut', 1500, 580),
  ('CFG', 'Chais.Faut.Glis', 3500, 334),
  ('C435', 'Class 40*35', 150, 782),
  ('C454', 'Class 45*40', 180, 1220);

select
  *
from
  produit;

-- Table Detail
-- DELETE FROM Detail;
INSERT INTO
  Detail
VALUES
  (30178, 'BC15156', 25),
  (30179, 'BP156', 60),
  (30179, 'BC15156', 260),
  (30179, 'CF', 15),
  (30179, 'CFG', 15),
  (30185, 'C435', 180),
  (30186, 'CFG', 70),
  (30188, 'C435', 92);

select
  *
from
  detail;

-------------
--  VIEWS  --
-------------
CREATE VIEW COM_COMPLETE (NCom, NCli, NOMCli, Loc, DateCom) AS
SELECT
  NCom,
  Com.NCli,
  NOM,
  Localite,
  DateCom
FROM
  Client Cli,
  Commande Com
WHERE
  Com.NCli = Cli.NCli;


-- qst 1
select ncli, nomcli, loc, COUNT(loc) from COM_COMPLETE
group by ncli, nomcli, loc;

CREATE VIEW Habitude_Achat (Localite, NProd, Volume) AS
SELECT
  Localite,
  P.NProd,
  SUM(QCom * Prix)
FROM
  Client Cli,
  Commande Com,
  Detail D,
  Produit P
GROUP BY
  Localite,
  P.NProd;

SELECT
  *
FROM
  Habitude_Achat;

create view Val_Stock_Actu(Stock, Valeur)
as select P.NProd, (QStock-SUM(D.QCom))*Prix
from Detail D, Produit P
group by P.NProd;

SELECT
  SUM(Valeur)
FROM
  Val_Stock_Actu;

-- drop view Cli;

create view Cli(NCli, Nom, Adresse, Localite, Cat, Compte) as
select NCli, Nom, Adresse, Localite, Cat, Compte
from Client
where Cat is null or Cat in ('B1', 'B2', 'C1', 'C2')
with check option;




