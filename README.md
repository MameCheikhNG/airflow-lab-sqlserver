# 🚀 Lab Apache Airflow + SQL Server

Ce projet est un **lab pratique** pour apprendre à utiliser [Apache Airflow](https://airflow.apache.org/) avec un pipeline ETL simple (Extract → Transform → Load) connecté à **SQL Server**.

## 📌 Objectifs pédagogiques

- Comprendre les concepts de base d’Airflow : DAG, Operator, Task, Scheduler, Executor.
- Installer et configurer Airflow avec **Docker Compose**.
- Configurer les connexions et variables dans l’UI d’Airflow.
- Créer un **DAG ETL** qui lit, transforme et charge des données dans SQL Server.

---

## ⚙️ Prérequis

- **Docker** et **Docker Compose** installés  
- Git
- SQL Server (fourni aussi en conteneur dans ce projet)

---

## 📂 Structure du projet

```
airflow-docker/
│── dags/
│   └── etl_customers.py        # DAG ETL principal
│── sql/
│   ├── init_raw_customers.sql  # Script création table RAW
│   ├── init_clean_customers.sql# Script création table CLEAN
│── docker-compose.yml          # Conteneurs Airflow + SQL Server
│── Dockerfile                  # Personnalisation image Airflow
│── requirements.txt            # Dépendances Python
│── README.md                   # Documentation
```

---

## 🚀 Installation

1. **Cloner le projet :**
   ```bash
   git clone <URL_GIT>
   cd airflow-docker
   ```

2. **Construire et lancer les conteneurs :**
   ```bash
   docker-compose up -d --build
   ```

3. **Accéder à l’interface Airflow :**
   - URL : [http://localhost:8080](http://localhost:8080)  
   - Utilisateur par défaut : `airflow`  
   - Mot de passe : `airflow`

4. **Accéder à SQL Server (conteneur) :**
   - Hôte : `localhost`
   - Port : `1433`
   - Utilisateur : `sa`
   - Mot de passe : `YourStrong!Passw0rd`

---

## 🔧 Configuration Airflow

⚠️ **Important** : Par défaut, la connexion **Microsoft SQL Server** n’apparaît pas dans la liste des hôtes supportés par Airflow.  
Il faut ajouter le provider et les dépendances nécessaires via un `Dockerfile` et un `requirements.txt`.

### Étape 1 : `requirements.txt`
Ajoute les paquets suivants :  
```txt
apache-airflow-providers-microsoft-mssql
pyodbc
pymssql
```

### Étape 2 : `Dockerfile`
Ajoute ce fichier à la racine de ton projet :  
```dockerfile
# Étape 1 : partir de l'image Airflow officielle
FROM apache/airflow:2.10.2

# Étape 2 : copier requirements.txt
COPY requirements.txt /requirements.txt

# Étape 3 : passer en utilisateur airflow pour installer les packages
USER airflow

# Étape 4 : installer les dépendances
RUN pip install --no-cache-dir -r /requirements.txt
```

Puis reconstruis ton environnement :  
```bash
docker-compose up -d --build
```

### Étape 3 : Créer la connexion SQL Server dans Airflow
- Aller dans **Admin → Connections**
- Créer une connexion :
  - Conn ID : `mssql_default`
  - Conn Type : `Microsoft SQL Server`
  - Host : `mssql`
  - Schema : `master`
  - Login : `sa`
  - Password : `YourStrong!Passw0rd`
  - Port : `1433`

### Étape 4 : Définir les variables Airflow
- `customer_raw_table` = `raw_customers`
- `customer_clean_table` = `clean_customers`

---

## 📊 Pipeline ETL

### Tables utilisées :
- **raw_customers** → données brutes avec doublons  
- **clean_customers** → données nettoyées

### DAG : `etl_customers`
- **extract** → lecture des données brutes  
- **transform** → suppression des doublons + mise en majuscules  
- **load** → insertion dans la table clean_customers  

---

## ✅ Résultat attendu

- La table `clean_customers` contient les données nettoyées.  
- Exemple :  
  ```
  raw_customers
  ┌──────────────┐
  │ name         │
  ├──────────────┤
  │ Alice        │
  │ alice        │
  │ Bob          │
  │ Bob          │
  └──────────────┘

  clean_customers
  ┌──────────────┐
  │ name         │
  ├──────────────┤
  │ ALICE        │
  │ BOB          │
  └──────────────┘
  ```

---

## 🛠️ Ressources utiles

- [Documentation officielle Airflow](https://airflow.apache.org/docs/)
- [Docker Airflow Setup](https://airflow.apache.org/docs/apache-airflow/stable/howto/docker-compose/index.html)
- [SQL Server Docker](https://hub.docker.com/_/microsoft-mssql-server)

---

👨‍💻 Auteur : **Mame Cheikh NGOM**  
#ApacheAirflow #DataEngineering #ETL #SQLServer #Automation
