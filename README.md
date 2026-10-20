# Railway: database-backed train search

The original browser schedule file has been removed. Train data is stored in
Cloudflare D1 (SQLite) in production, and a separate local D1 database in preview.
Schedules remain illustrative samples, not verified railway information.

## Database tables

| Table | Key | Contents |
| --- | --- | --- |
| `stations` | `code` | Station codes and names |
| `trains` | `number` | Train names and categories |
| `train_stops` | `train_number`, `stop_order` | Ordered station references, arrival/departure times and day offsets |

Foreign keys link stops to stations and trains. An index supports station lookup.
Day 0 is the train's departure day; day 1 is the next day. Times use IST.

`db/schema.ts` declares the schema; `drizzle/` contains generated schema-only
migrations. `db/seed.sql` contains the 24 stations, 11 trains, and their stops.
The server seeds an empty, migrated database atomically on its first data request.
Seed inserts are idempotent; a non-empty database is not automatically reseeded.
Editing the seed file does not update existing hosted records.

## API and browser behavior

- `GET /api/stations`: reads the station directory from D1.
- `GET /api/trains?from=NDLS&to=JP`: validates codes and queries D1 for trains
  that visit the origin before the destination. Returns just that journey segment
  with its timings, duration and relative arrival day.
- Bad inputs return 400; database failures return 503 and the page offers retry.
- All SQL input values use bound parameters. There is no public SQL or write API.
- Private-site access continues to be enforced by Sites.
- The browser holds station suggestions and current results in memory. It does
  not download the full train dataset or persist user searches.

## Development

Use Node 22.13+ and the bundled npm scripts. Install with `npm run install:ci`.
After schema edits, run `npm run db:generate`, inspect the SQL, and build with
`npm run build`. Apply each pending SQL migration to the local D1 database:

```
node --import ./scripts/sites-env.mjs ./node_modules/wrangler/bin/wrangler.js d1 execute DB --local --config dist/server/wrangler.json --persist-to .wrangler/state --file drizzle/0000_damp_firedrake.sql
```

Use the actual generated filename. Run `npm run dev` for preview and
`node --test tests/database.test.js` for real SQLite integration tests.
Local D1 files are in ignored `.wrangler/state/`; hosted D1 is separate.
Sites applies hosted schema migrations when publishing. The `DB` binding is
declared in `.openai/hosting.json`; no database credentials are sent to browsers.
