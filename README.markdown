# Système de Gestion de Bibliothèque

## Description
Ce projet est un système de gestion de bibliothèque basé sur une base de données relationnelle implémentée en **PostgreSQL**. Il permet de gérer les livres, les utilisateurs, les emprunts et les catégories de livres, avec des fonctionnalités avancées comme des triggers pour gérer la disponibilité des livres et des requêtes complexes pour extraire des informations utiles. Ce projet démontre des compétences en conception de bases de données, normalisation, requêtes SQL, et gestion des contraintes d'intégrité.

L'objectif est de fournir une solution robuste et extensible pour une bibliothèque, tout en mettant en avant des bonnes pratiques de développement de bases de données.

## Fonctionnalités
- **Gestion des livres** : Ajout, modification et suivi des livres (titre, auteur, ISBN, catégorie, disponibilité).
- **Gestion des utilisateurs** : Enregistrement des utilisateurs avec leurs informations (nom, email, date d'inscription).
- **Gestion des emprunts** : Suivi des emprunts avec dates d'emprunt, de retour, et calcul des pénalités potentielles.
- **Gestion des catégories** : Organisation des livres par genres littéraires (roman, science-fiction, etc.).
- **Trigger automatisé** : Mise à jour automatique de la disponibilité d'un livre lorsqu'il est emprunté ou retourné.
- **Requêtes avancées** :
  - Liste des livres empruntés avec les détails de l'utilisateur.
  - Recherche de livres par auteur, catégorie ou disponibilité.
- **Normalisation** : La base de données est en 3ème forme normale (3NF) pour minimiser la redondance et assurer l'intégrité des données.

## Technologies utilisées
- **SGBD** : PostgreSQL
- **Langage** : SQL
- **Outils** : psql (pour exécuter les scripts), pgAdmin (optionnel pour la visualisation)
- **Concepts clés** :
  - Modélisation relationnelle
  - Contraintes d'intégrité (clés primaires, clés étrangères, unicité)
  - Triggers et fonctions PL/pgSQL
  - Requêtes complexes (JOIN, GROUP BY, CASE)

## Structure de la base de données
La base de données est composée de 4 tables principales :
1. **Categories** : Stocke les genres littéraires (ex. Roman, Science-Fiction).
2. **Livres** : Contient les informations sur les livres (titre, auteur, ISBN, disponibilité).
3. **Utilisateurs** : Gère les informations des utilisateurs (nom, email, date d'inscription).
4. **Emprunts** : Enregistre les emprunts avec les dates et les pénalités.

### Diagramme ERD (Entity-Relationship Diagram)
```
+--------------+       +--------------+       +--------------+
|  Categories  |       |    Livres    |       | Utilisateurs |
+--------------+       +--------------+       +--------------+
| id_categorie |<----1-| id_categorie |       | id_utilisateur |
| nom_categorie|       | id_livre     |       | nom           |
+--------------+       | titre        |       | email         |
                      | auteur       |       | date_inscription |
                      | isbn         |       +--------------+
                      | disponible   |              |
                      +--------------+              |
                           |                       |
                           1                       N
                           |                       |
                      +--------------+
                      |   Emprunts   |
                      +--------------+
                      | id_emprunt   |
                      | id_livre     |N
                      | id_utilisateur|-----1
                      | date_emprunt |
                      | date_retour  |
                      | penalite     |
                      +--------------+
```

## Prérequis
- **PostgreSQL** : Version 13 ou supérieure installée localement ou sur un service cloud (ex. Neon, Heroku).
- **psql** : Client en ligne de commande pour exécuter les scripts SQL.
- (Optionnel) **pgAdmin** ou un autre outil de gestion de bases de données pour une interface graphique.

## Installation
1. **Cloner le dépôt** :
   ```bash
   git clone https://github.com/[votre-nom-utilisateur]/Library-Management-Database.git
   cd Library-Management-Database
   ```

2. **Créer la base de données** :
   - Connectez-vous à PostgreSQL via `psql` :
     ```bash
     psql -U postgres
     ```
   - Créez la base de données :
     ```sql
     CREATE DATABASE bibliotheque;
     ```

3. **Exécuter le script SQL** :
   - Depuis le répertoire du projet, exécutez le script principal :
     ```bash
     psql -U postgres -d bibliotheque -f library_database.sql
     ```
   - Ce script crée les tables, insère des données d'exemple, configure un trigger et fournit une requête avancée.

4. **Vérifier l'installation** :
   - Connectez-vous à la base `bibliotheque` via `psql` :
     ```bash
     psql -U postgres -d bibliotheque
     ```
   - Vérifiez les tables créées :
     ```sql
     \dt
     ```
   - Testez une requête, par exemple :
     ```sql
     SELECT * FROM Livres;
     ```

## Exemple d'utilisation
Voici quelques exemples de requêtes incluses dans le script `library_database.sql` :

1. **Lister les livres empruntés avec les détails de l'utilisateur** :
   ```sql
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
   ```

   Résultat attendu :
   ```
   titre           | auteur           | emprunteur    | date_emprunt | statut
   ----------------|------------------|---------------|--------------|------------
   Les Misérables  | Victor Hugo      | Jean Dupont   | 2025-05-20   | Non retourné
   Dune            | Frank Herbert    | Marie Curie   | 2025-05-15   | Retourné
   ```

2. **Rechercher les livres disponibles** :
   ```sql
   SELECT titre, auteur FROM Livres WHERE disponible = TRUE;
   ```

3. **Vérifier les emprunts en retard** (par exemple, plus de 14 jours) :
   ```sql
   SELECT 
       l.titre, 
       u.nom, 
       e.date_emprunt 
   FROM Emprunts e
   JOIN Livres l ON e.id_livre = l.id_livre
   JOIN Utilisateurs u ON e.id_utilisateur = u.id_utilisateur
   WHERE e.date_retour IS NULL AND e.date_emprunt < CURRENT_DATE - INTERVAL '14 days';
   ```

## Compétences démontrées
- **Conception de bases de données** : Modélisation relationnelle et normalisation (3NF).
- **SQL** : Création de tables, contraintes (PRIMARY KEY, FOREIGN KEY, UNIQUE), requêtes complexes avec JOIN, CASE, et GROUP BY.
- **PL/pgSQL** : Utilisation de triggers et fonctions pour automatiser les mises à jour.
- **Documentation** : Rédaction d'un README clair et structuré pour une prise en main facile.
- **Bonnes pratiques** : Gestion des erreurs, commentaires dans le code, et organisation du projet.

## Améliorations possibles
- Ajouter une interface web avec **Flask** ou **Django** pour interagir avec la base de données.
- Implémenter des procédures stockées pour calculer automatiquement les pénalités de retard.
- Créer des vues pour des rapports comme les livres les plus empruntés ou les utilisateurs les plus actifs.
- Déployer la base de données sur un service cloud comme **Neon** pour une démo en ligne.
- Ajouter des tests unitaires pour valider les requêtes SQL avec un framework comme **pytest**.

## Auteur
[Votre Nom]  
[Liens vers votre GitHub, LinkedIn, ou portfolio]

## Licence
Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.