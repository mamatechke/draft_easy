Deployment to Koyeb
===================

This app is Docker-ready (see `Dockerfile`) and includes a `Procfile` for process hints.

Summary: I've committed the layout changes and pushed them to `main`. The repo can be deployed to Koyeb by building the Docker image from the repository and providing the required runtime environment variables and a database.

Checklist (what Koyeb needs)
- A GitHub repo connected to Koyeb (or push an image to a registry)
- Build from the repository's `Dockerfile` (present at project root)
- Environment variables/secrets:
  - `RAILS_ENV=production`
  - `RAILS_MASTER_KEY` (from `config/master.key` / Rails credentials)
  - `DATABASE_URL` (pointing to a Postgres instance)
  - `SECRET_KEY_BASE` (if not using `RAILS_MASTER_KEY` to derive)
  - Any external API keys the app uses (e.g. SendGrid, Stripe, etc.)

Database
- Koyeb does not (yet) provide a managed Postgres in the same workflow — create a managed Postgres service (on Koyeb or elsewhere) and set `DATABASE_URL`.

Steps (web UI)
1. Go to https://app.koyeb.com and sign in.
2. Create a new App -> choose "Deploy from Git" and connect your GitHub repo `OWNER/REPO`.
3. Select branch `main` and build context `.`. Choose the `Dockerfile` build option.
4. Add environment variables (set sensitive values as secrets): `RAILS_ENV=production`, `RAILS_MASTER_KEY`, `DATABASE_URL`, and other secrets.
5. Choose the service port `80` (Dockerfile exposes 80). Configure resource size and autoscaling as desired.
6. Provision or attach a Postgres instance and set its connection URL to `DATABASE_URL`.
7. Deploy — Koyeb will build the Docker image and start the container. The entrypoint runs `./bin/rails db:prepare` on first boot so DB must be reachable.

CLI / koyeb.yml (optional)
If you prefer the Koyeb CLI or manifest, create a `koyeb.yml` in the repo. Example skeleton (fill secrets via `koyeb secret`):

```yaml
version: 1
apps:
  - name: draft-easy
    services:
      - name: web
        source:
          type: github
          repo: OWNER/REPO
          branch: main
          path: .
        build:
          dockerfile: Dockerfile
        ports:
          - 80
        env:
          - name: RAILS_ENV
            value: production
          - name: DATABASE_URL
            value_from_secret: DATABASE_URL
          - name: RAILS_MASTER_KEY
            value_from_secret: RAILS_MASTER_KEY
```

Notes & gotchas
- Ensure `RAILS_MASTER_KEY` and `DATABASE_URL` are set before the container boots — the Docker entrypoint runs `rails db:prepare`.
- If you use Active Storage with local disk, adjust configuration to use a cloud storage provider (S3-compatible) for production.
- If you use Redis (ActionCable, Sidekiq), provision a Redis instance and set `REDIS_URL`.

If you want, I can:
- try to run a Koyeb deployment using the Koyeb CLI from this environment (requires your Koyeb API key), or
- prepare a `koyeb.yml` with the repo info and leave secrets as references for you to populate.
