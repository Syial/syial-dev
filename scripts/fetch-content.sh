#!/usr/bin/env bash
set -euo pipefail

# Sync le contenu privé :
#   Markdown → src/content/{projets,writeups}
#   Images   → public/images/{projets,writeups}
#
# Modes :
#   1. Clone GitHub (défaut) — CONTENT_GITHUB_TOKEN requis
#   2. Dossier local — CONTENT_LOCAL=/chemin/vers/syial-content
#      (utile en dev : pas besoin de token / re-clone)

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if [[ -f "$ROOT/.env" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "$ROOT/.env"
  set +a
fi

REPO="${CONTENT_REPO:-Syial/syial-content}"
TOKEN="${CONTENT_GITHUB_TOKEN:-}"
LOCAL="${CONTENT_LOCAL:-}"

TMP=""
cleanup() {
  if [[ -n "$TMP" ]]; then
    rm -rf "$TMP"
  fi
}
trap cleanup EXIT

if [[ -n "$LOCAL" ]]; then
  if [[ ! -d "$LOCAL" ]]; then
    echo "CONTENT_LOCAL introuvable : $LOCAL"
    exit 1
  fi
  SRC="$LOCAL"
  echo "→ Contenu local : $SRC"
else
  if [[ -z "$TOKEN" ]]; then
    echo "CONTENT_GITHUB_TOKEN manquant (ou définis CONTENT_LOCAL vers ton clone)."
    echo "En local : renseigne .env (voir .env.example)."
    exit 1
  fi
  TMP="$(mktemp -d)"
  echo "→ Clone $REPO …"
  git clone --depth 1 \
    "https://x-access-token:${TOKEN}@github.com/${REPO}.git" \
    "$TMP/content"
  SRC="$TMP/content"
fi

if [[ ! -d "$SRC/projets" || ! -d "$SRC/writeups" ]]; then
  echo "Le contenu doit exposer projets/ et writeups/ à la racine."
  exit 1
fi

mkdir -p "$ROOT/src/content"
rm -rf "$ROOT/src/content/projets" "$ROOT/src/content/writeups"
cp -R "$SRC/projets" "$SRC/writeups" "$ROOT/src/content/"
echo "→ Contenu synchronisé dans src/content/"

mkdir -p "$ROOT/public/images"
rm -rf "$ROOT/public/images/projets" "$ROOT/public/images/writeups"

if [[ -d "$SRC/images/projets" ]]; then
  cp -R "$SRC/images/projets" "$ROOT/public/images/"
else
  mkdir -p "$ROOT/public/images/projets"
fi

if [[ -d "$SRC/images/writeups" ]]; then
  cp -R "$SRC/images/writeups" "$ROOT/public/images/"
else
  mkdir -p "$ROOT/public/images/writeups"
fi

echo "→ Images synchronisées dans public/images/"
