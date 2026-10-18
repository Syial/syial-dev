# syial.dev

Personal site — [syial.dev](https://syial.dev)

Static portfolio for projects and writeups (cybersecurity, systems, reverse engineering). Content-first layout: one column, cream paper grain, framed entries.

## Architecture

The **site** and the **content** are separate.

| Repo | Role |
|------|------|
| `Syial/syial-dev` (this one) | Theme, pages, build & deploy |
| `Syial/syial-content` (private) | Markdown (`projets/`, `writeups/`) and media (`images/`) |

At build time, `scripts/fetch-content.sh` pulls the private repo into `src/content/` and `public/images/` (both gitignored here). Locally you can point `CONTENT_LOCAL` at a clone instead of using a token.

## Stack

Astro 7 · Tailwind CSS v4 · Cloudflare Workers

## Deploy

Push to `main` → GitHub Actions → fetch private content → Astro build → Cloudflare Workers.
