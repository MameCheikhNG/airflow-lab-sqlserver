# Étape 1 : partir de l'image Airflow officielle
FROM apache/airflow:2.10.2

USER root

# Installer les dépendances système
RUN apt-get update && apt-get install -y \
    curl gnupg2 apt-transport-https unixodbc-dev \
 && rm -rf /var/lib/apt/lists/*

# Ajouter la clé Microsoft et le repository
RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc \
    | gpg --dearmor \
    | tee /usr/share/keyrings/microsoft-prod.gpg > /dev/null \
 && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-prod.gpg] https://packages.microsoft.com/debian/12/prod bookworm main" \
    > /etc/apt/sources.list.d/mssql-release.list \
 && apt-get update

# Installer le driver ODBC pour SQL Server
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17

# Copier requirements
COPY requirements.txt /requirements.txt

# Repasser en user airflow pour installer les dépendances Python
USER airflow
RUN pip install --no-cache-dir -r /requirements.txt
