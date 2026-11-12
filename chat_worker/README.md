# Portfolio chat worker

Small Cloudflare Worker behind the portfolio chatbot. Ready answers are handled in the Flutter app
(`lib/chatbot/knowledge_base.dart`); any other question comes here, and Gemini answers it using only
`src/profile.ts` as context. The same worker sends contact-form email through Brevo (`/contact`).

- Model: set by `GEMINI_MODEL` in `wrangler.toml` (default `gemini-flash-latest`), short replies.
- Safety: only the portfolio's origins may call it (CORS), 10 questions per minute per visitor,
  messages trimmed to 800 characters and the last 10 turns. Off-profile questions are declined.
- Keys (`GEMINI_API_KEY`, `BREVO_API_KEY`) are Worker secrets. They never appear in the website or this repo.

## Deploy (once)

```bash
cd chat_worker
npm install
npx wrangler login                          # free Cloudflare account
npx wrangler secret put GEMINI_API_KEY      # key from aistudio.google.com/apikey (free tier)
npx wrangler secret put BREVO_API_KEY       # xkeysib-… API key from Brevo
npm run deploy                              # prints https://portfolio-chat.<you>.workers.dev
```

Then set `WorkerApi.baseUrl` in `lib/services/worker_api.dart` to that URL, rebuild and deploy the site.

## Update what the bot knows

Edit `src/profile.ts`, then run `npm run deploy`. No change to the website is needed.

## Local test

```bash
echo 'GEMINI_API_KEY=...' > .dev.vars   # git-ignored
npm run dev                                         # http://localhost:8787
```
