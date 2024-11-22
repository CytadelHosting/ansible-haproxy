#!/bin/bash

CERT_DIR="/etc/haproxy/certs"
LETSENCRYPT_LIVE_DIR="/etc/letsencrypt/live"

mkdir -p ${CERT_DIR}

# Parcourir chaque dossier dans /etc/letsencrypt/live
for DOMAIN_DIR in "$LETSENCRYPT_LIVE_DIR"/*; do
    # Vérifier si c'est bien un dossier
    if [ -d "$DOMAIN_DIR" ]; then
        DOMAIN=$(basename "$DOMAIN_DIR")
        PRIVKEY="$DOMAIN_DIR/privkey.pem"
        FULLCHAIN="$DOMAIN_DIR/fullchain.pem"
        OUTPUT_CERT="$CERT_DIR/$DOMAIN.pem"

        # Vérifier que privkey.pem et fullchain.pem existent
        if [ -f "$PRIVKEY" ] && [ -f "$FULLCHAIN" ]; then
            # Concaténer les fichiers de certificat et de clé dans le fichier de sortie
            sudo cat "$PRIVKEY" "$FULLCHAIN" > "$OUTPUT_CERT"
            echo "Certificat généré pour $DOMAIN et placé dans $OUTPUT_CERT"
        else
            echo "Fichiers nécessaires manquants pour $DOMAIN, certificat non généré."
        fi
    fi
done

systemctl reload haproxy
