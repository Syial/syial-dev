#!/usr/bin/env bash
set -euo pipefail

# Clone le repo de contenu privé dans src/content/{projets,writeups}.
# Variables :
#   CONTENT_GITHUB_TOKEN  (obligatoire)
#   CONTENT_REPO          (Syial/syial-content)

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if [[ -f "$ROOT/.env" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "$ROOT/.env"
  set +a
fi

REPO="${CONTENT_REPO:-Syial/syial-content}"
TOKEN="${CONTENT_GITHUB_TOKEN:-}"

if [[ -z "$TOKEN" ]]; then
  echo "CONTENT_GITHUB_TOKEN manquant."
  echo "En local : renseigne-le dans .env (voir .env.example)."
  echo "Sur Cloudflare : Settings → Environment variables."
  exit 1
fi

TMP="$(mktemp -d)"
cleanup() { rm -rf "$TMP"; }
trap cleanup EXIT

echo "→ Clone $REPO …"
git clone --depth 1 \
  "https://x-access-token:${TOKEN}@github.com/${REPO}.git" \
  "$TMP/content"

mkdir -p "$ROOT/src/content"
rm -rf "$ROOT/src/content/projets" "$ROOT/src/content/writeups"

if [[ ! -d "$TMP/content/projets" || ! -d "$TMP/content/writeups" ]]; then
  echo "Le repo $REPO doit contenir les dossiers projets/ et writeups/ à la racine."
  exit 1
fi

cp -R "$TMP/content/projets" "$TMP/content/writeups" "$ROOT/src/content/"
echo "→ Contenu synchronisé dans src/content/"
