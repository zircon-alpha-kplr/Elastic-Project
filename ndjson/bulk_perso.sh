# Vérifie si le premier argument est vide
if [ -z "$1" ]; then
  echo "Usage: ./bulk_ingest.sh <index_name> [num_files]"
  echo "       ./bulk_ingest.sh <index_name>"
  echo "        |---- Ingests all .ndjson files in the current directory"
  echo "Options:"
  echo "  <index_name>: Name of the Elasticsearch index to ingest data into"
  echo "  <num_files>: Number of .ndjson files to ingest."
  echo "               Default: ingest all files in the current directory"
  exit 1
fi

# Si le deuxième argument est fourni, utilisez-le comme limite, sinon utilisez tous les fichiers .ndjson
if [ -n "$2" ]; then
  limit=$2
else
  limit=$(ls -1 *.ndjson | wc -l)
fi

# Affiche le nombre maximum de fichiers qui seront traités
echo "Processing up to $limit .ndjson files to index '$1'"

# Initialise le compteur à 1
i=1

# Pour chaque fichier .ndjson dans le répertoire courant
for file in *.ndjson; do
  # Si nous avons atteint la limite, sortez de la boucle
  if [ "$i" -gt "$limit" ]; then
    break
  fi
  # Envoie une requête POST Elasticsearch pour indexer les données du fichier courant dans l'index spécifié
  curl -s -H "Content-Type: application/x-ndjson" -XPOST "localhost:9200/$1/_bulk" --data-binary "@$file" > /dev/null
  echo "Indexed file: $file"
  # Incrémente le compteur
  i=$((i+1))
done
