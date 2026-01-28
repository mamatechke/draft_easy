# Railway.app Deployment Configuration for DraftEasy

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new/template?template=https://github.com/Tich-Labs/rails-daisy-ui-boilerplate)

## Getting Started on Railway

1. **Click the Railway button above** to deploy this app to Railway.
2. **Set the following environment variables** in Railway:
   - `RAILS_ENV=production`
   - `RAILS_MASTER_KEY` (from your local `config/credentials.yml.enc`)
   - `DATABASE_URL` (auto-provided by Railway PostgreSQL plugin)
   - `RAILS_SERVE_STATIC_FILES=true`
   - `RAILS_LOG_TO_STDOUT=true`
   - `SECRET_KEY_BASE` (auto-generated or from `rails secret`)
3. **Provision a PostgreSQL database** via Railway plugins.
4. **Run database migrations** after deploy: `rails db:migrate`.
5. **(Optional) Set up Active Storage**: Use Railway's S3-compatible storage or another provider.

## Procfile
```
web: bundle exec puma -C config/puma.rb
assets: yarn build:css && rails assets:precompile
```

## Notes
- **Ollama/AI Summarization**: The AI summarization feature (Ollama/llama3) requires a local Ollama server and will NOT work on Railway cloud. Summarization is only available in local/dev environments.
- **PDF Extraction**: PDF extraction works in all environments.
- **Static Assets**: Assets are built with Tailwind CSS and DaisyUI. Ensure `assets` process runs before `web`.

## Useful Commands
- `rails db:migrate` — Run database migrations
- `rails assets:precompile` — Precompile assets for production
- `yarn build:css` — Build Tailwind CSS

## Troubleshooting
- If you see errors about missing master key, set `RAILS_MASTER_KEY` in Railway environment variables.
- For asset issues, ensure the `assets` process completes before the web process starts.

---

For more details, see the [Railway Docs](https://docs.railway.app/) and [Ruby on Rails Deployment Guide](https://guides.rubyonrails.org/deployment.html).
