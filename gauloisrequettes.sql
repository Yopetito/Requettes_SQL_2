---1. Nom des lieux qui finissent par 'um'.
SELECT lieu.nom_lieu
FROM lieu
WHERE nom_lieu LIKE '%um'

--2. Nombre de personnages par lieu (trié par nombre de personnages décroissant).
SELECT lieu.nom_lieu, COUNT(personnage.id_personnage) AS Habitants
FROM lieu

INNER JOIN personnage
ON lieu.id_lieu = personnage.id_lieu

GROUP BY lieu.id_lieu

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

GROUP BY specialite.id_specialite

ORDER BY Nombre_personnage DESC

--5 Nom, date et lieu des batailles, classées de la plus récente à la plus ancienne (dates affichées
au format jj/mm/aaaa).

SELECT bataille.nom_bataille, DATE_FORMAT(bataille.date_bataille, "%e / %c / %Y") AS Date_Anciennete, lieu.nom_lieu
FROM bataille

INNER JOIN lieu
ON bataille.id_lieu = lieu.id_lieu

ORDER BY bataille.date_bataille DESC

---6. Nom des potions + coût de réalisation de la potion (trié par coût décroissant).
SELECT potion.nom_potion, SUM(composer.qte * ingredient.cout_ingredient) AS Cout
FROM potion

INNER JOIN composer
ON potion.id_potion = composer.id_potion

INNER JOIN ingredient
ON composer.id_ingredient = ingredient.id_ingredient

GROUP BY potion.nom_potion

ORDER BY Cout DESC

--7. Nom des ingrédients + coût + quantité de chaque ingrédient qui composent la potion 'Santé'.

SELECT potion.nom_potion,
	ingredient.nom_ingredient,
	composer.qte,
	SUM(ingredient.cout_ingredient * composer.qte) AS PrixTotal
FROM potion

INNER JOIN composer
ON potion.id_potion = composer.id_potion

INNER JOIN ingredient
ON composer.id_ingredient = ingredient.id_ingredient

WHERE potion.nom_potion = 'Santé'

--8. Nom du ou des personnages qui ont pris le plus de casques dans la bataille 'Bataille du village
--gaulois'.

-- HAVING - ALL - Comparer les valeur afin de prendre le plus elevé.
SELECT personnage.nom_personnage, SUM(prendre_casque.qte) AS QttCasque
FROM personnage

INNER JOIN prendre_casque
ON personnage.id_personnage = prendre_casque.id_personnage

INNER JOIN bataille
ON prendre_casque.id_bataille = bataille.id_bataille

WHERE bataille.nom_bataille = 'Bataille du village gaulois'

GROUP BY personnage.id_personnage 

HAVING QttCasque >= ALL (
	SELECT SUM(prendre_casque.qte) AS QttCasque
	FROM personnage

	INNER JOIN prendre_casque
	ON personnage.id_personnage = prendre_casque.id_personnage
	
	INNER JOIN bataille
	ON prendre_casque.id_bataille = bataille.id_bataille
	
	WHERE bataille.nom_bataille = 'Bataille du village gaulois'
	
	GROUP BY personnage.id_personnage 
	)

--- WITH prendre toutes les valeurs et apres recuperer le plus elevé
WITH quiALePlusDeCasques AS (
	SELECT personnage.nom_personnage, SUM(prendre_casque.qte) AS QttCasque
	FROM personnage
	
	INNER JOIN prendre_casque
	ON personnage.id_personnage = prendre_casque.id_personnage
	
	INNER JOIN bataille
	ON prendre_casque.id_bataille = bataille.id_bataille

	WHERE bataille.nom_bataille = 'Bataille du village gaulois'

	GROUP BY personnage.id_personnage
	)

SELECT nom_personnage, QttCasque
FROM quiALePlusDeCasques
WHERE QttCasque = (SELECT MAX(QttCasque) FROM quiALePlusDeCasques);

--9. Nom des personnages et leur quantité de potion bue (en les classant du plus grand buveur
--au plus petit).

SELECT personnage.nom_personnage, SUM(boire.dose_boire) AS DosePotion
FROM personnage 

INNER JOIN boire
ON personnage.id_personnage = boire.id_personnage

GROUP BY personnage.nom_personnage

ORDER BY DosePotion DESC

--10 Nom de la bataille où le nombre de casques pris a été le plus important.

SELECT bataille.nom_bataille, SUM(prendre_casque.qte) AS QttCasques
FROM bataille

INNER JOIN prendre_casque
ON bataille.id_bataille = prendre_casque.id_bataille

GROUP BY bataille.id_bataille

HAVING QttCasques >= ALL (
	SELECT SUM(prendre_casque.qte) AS QttCasques
	FROM bataille
	
	INNER JOIN prendre_casque
	ON bataille.id_bataille = prendre_casque.id_bataille
	
	GROUP BY bataille.id_bataille
	)

--11. Combien existe-t-il de casques de chaque type et quel est leur coût total ? (classés par
--nombre décroissant)

SELECT type_casque.nom_type_casque, COUNT(casque.id_type_casque) AS Casques_Appartenant_au_Type, SUM(casque.cout_casque) AS Cout_Total
FROM type_casque

INNER JOIN casque
ON type_casque.id_type_casque = casque.id_type_casque

GROUP BY type_casque.id_type_casque

ORDER BY Casques_Appartenant_Au_Type DESC

--12. Nom des potions dont un des ingrédients est le poisson frais.

SELECT potion.nom_potion
FROM potion

INNER JOIN composer
ON potion.id_potion = composer.id_potion

INNER JOIN ingredient
ON composer.id_ingredient = ingredient.id_ingredient

WHERE ingredient.nom_ingredient = 'Poisson frais'

--13. Nom du / des lieu(x) possédant le plus d'habitants, en dehors du village gaulois*/
SELECT lieu.nom_lieu, COUNT(personnage.id_lieu) AS Habitants
FROM lieu

INNER JOIN personnage
ON lieu.id_lieu = personnage.id_lieu

WHERE lieu.nom_lieu NOT IN('Village gaulois')

GROUP BY lieu.id_lieu

HAVING Habitants >= ALL(
	SELECT COUNT(personnage.id_lieu) AS Habitants
	FROM lieu
	
	INNER JOIN personnage
	ON lieu.id_lieu = personnage.id_lieu
	
	WHERE lieu.nom_lieu NOT IN('Village gaulois')
	
	GROUP BY lieu.id_lieu
	)

--14. Nom des personnages qui n'ont jamais bu aucune potion.
    
SELECT personnage.nom_personnage
FROM personnage

LEFT JOIN boire
ON personnage.id_personnage = boire.id_personnage

WHERE boire.id_potion IS NULL

--15. Nom du / des personnages qui n'ont pas le droit de boire de la potion 'Magique'.
SELECT personnage.nom_personnage
FROM personnage

INNER JOIN autoriser_boire
ON personnage.id_personnage = autoriser_boire.id_personnage

WHERE autoriser_boire.id_potion NOT IN(
	SELECT autoriser_boire.id_potion
	FROM autoriser_boire
	
	WHERE autoriser_boire.id_potion = 1
	)


