-- Création de la base de données
CREATE DATABASE bibliotheque;
\c bibliotheque;

-- Table des catégories
CREATE TABLE Categories (
    id_categorie SERIAL PRIMARY KEY,
    nom_categorie VARCHAR(50) NOT NULL
);

-- Table des livres
CREATE TABLE Livres (
    id_livre SERIAL PRIMARY KEY,
    titre VARCHAR(100) NOT NULL,
    auteur VARCHAR(50) NOT NULL,
    isbn VARCHAR(13) UNIQUE NOT NULL,
    id_categorie INT REFERENCES Categories(id_categorie),
    disponible BOOLEAN DEFAULT TRUE
);

-- Table des utilisateurs
CREATE TABLE Utilisateurs (
    id_utilisateur SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    date_inscription DATE DEFAULT CURRENT_DATE
);

-- Table des emprunts
CREATE TABLE Emprunts (
    id_emprunt SERIAL PRIMARY KEY,
    id_livre INT REFERENCES Livres(id_livre),
    id_utilisateur INT REFERENCES Utilisateurs(id_utilisateur),
    date_emprunt DATE NOT NULL DEFAULT CURRENT_DATE,
    date_retour DATE,
    penalite DECIMAL(5,2) DEFAULT 0.00
);

-- Trigger pour mettre à jour la disponibilité des livres
CREATE OR REPLACE FUNCTION update_disponibilite_livre()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.date_retour IS NULL THEN
        UPDATE Livres SET disponible = FALSE WHERE id_livre = NEW.id_livre;
    ELSE
        UPDATE Livres SET disponible = TRUE WHERE id_livre = NEW.id_livre;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_disponibilite
AFTER INSERT OR UPDATE ON Emprunts
FOR EACH ROW EXECUTE FUNCTION update_disponibilite_livre();

-- Insertion de données d'exemple
INSERT INTO Categories (nom_categorie) VALUES
('Roman'), ('Science-Fiction'), ('Histoire');

INSERT INTO Livres (titre, auteur, isbn, id_categorie, disponible) VALUES
('Les Misérables', 'Victor Hugo', '9781234567890', 1, TRUE),
('Dune', 'Frank Herbert', '9780987654321', 2, TRUE),
('Sapiens', 'Yuval Noah Harari', '9781122334455', 3, TRUE);

INSERT INTO Utilisateurs (nom, email) VALUES
('Jean Dupont', 'jean.dupont@email.com'),
('Marie Curie', 'marie.curie@email.com');

INSERT INTO Emprunts (id_livre, id_utilisateur, date_emprunt, date_retour) VALUES
(1, 1, '2025-05-20', NULL),
(2, 2, '2025-05-15', '2025-05-22');

-- Requête avancée : Liste des livres empruntés avec les détails de l'utilisateur
SELECT 
    l.titre, 
    l.auteur, 
    u.nom AS emprunteur, 
    e.date_emprunt,
    CASE 
        WHEN e.date_retour IS NULL THEN 'Non retourné'
        ELSE 'Retourné'
    END AS statut
FROM Livres l
JOIN Emprunts e ON l.id_livre = e.id_livre
JOIN Utilisateurs u ON e.id_utilisateur = u.id_utilisateur;
