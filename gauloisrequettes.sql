---1. Nom des lieux qui finissent par 'um'.
SELECT lieu.nom_lieu
FROM lieu
WHERE nom_lieu LIKE '%um'

--2. Nombre de personnages par lieu (trié par nombre de personnages décroissant).
SELECT lieu.nom_lieu, COUNT(personnage.id_personnage) AS Habitants
FROM lieu

INNER JOIN personnage
ON lieu.id_lieu = personnage.id_lieu

GROUP BY lieu.nom_lieu

ORDER BY Habitants DESC

--3. Nom des personnages + spécialité + adresse et lieu d'habitation, triés par lieu puis par nom
de personnage.

SELECT personnage.nom_personnage, specialite.nom_specialite, personnage.adresse_personnage, lieu.nom_lieu
FROM personnage

INNER JOIN specialite
ON personnage.id_specialite = specialite.id_specialite

INNER JOIN lieu
ON personnage.id_lieu = lieu.id_lieu

ORDER BY lieu.nom_lieu, personnage.nom_personnage

--4Nom des spécialités avec nombre de personnages par spécialité (trié par nombre de
personnages décroissant).

SELECT specialite.nom_specialite, COUNT(personnage.id_personnage) AS Nombre_personnage
FROM specialite

INNER JOIN personnage
ON specialite.id_specialite = personnage.id_specialite

GROUP BY specialite.nom_specialite

ORDER BY Nombre_personnage DESC

--5 Nom, date et lieu des batailles, classées de la plus récente à la plus ancienne (dates affichées
au format jj/mm/aaaa).

SELECT bataille.nom_bataille, DATE_FORMAT(bataille.date_bataille, "%e / %c / %Y") AS Date_Anciennete, lieu.nom_lieu
FROM bataille

INNER JOIN lieu
ON bataille.id_lieu = lieu.id_lieu

ORDER BY bataille.date_bataille DESC

---6. Nom des potions + coût de réalisation de la potion (trié par coût décroissant).
