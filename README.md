# Railway: database-backed train search

## Java Spring Boot backend

`backend/` adds a Java 17 / Spring Boot 4.1.1 API and persistent H2 database,
with PostgreSQL and Docker Compose configuration for deployment. It serves the
frontend itself at `http://localhost:8080`, connected to the Java API. See
`backend/README.md` for startup commands, table definitions, API examples, tests,
and how to connect GitHub Pages to a deployed HTTPS backend.

Search results now include Train details, Full train schedule, and Calculate
sample fare controls. The API and SQLite demo both support these features.
All schedules and fares are illustrative. Booking and cancellation are not
implemented in this first phase.

## GitHub-only deployment

The standalone version in `docs/` runs entirely on GitHub Pages. It downloads
`docs/data/railway.sqlite` (a real SQLite database with the same four data tables)
and queries it in the browser using a bundled SQLite WebAssembly engine.
The page, database, scripts, and engine assets are all served by GitHub Pages;
no external database server, API, CDN, or credentials are required.

To regenerate after changing the SQL data, run `npm run build:pages` and
`npm run test:pages`. Upload the entire `docs/` folder, including `data/`,
`vendor/`, `db/`, and `pages/`, to the repository. In repository Settings → Pages,
select **Deploy from a branch**, branch **main**, folder **/docs**, and Save.
The URL for this repository is `https://soma-gayathri.github.io/train-ticket/`.

The database is a public, read-only snapshot. It contains 212 stations, 11 trains,
69 stops, and four sample fare rules. Searches do not modify it. To change records, edit `db/seed.sql`,
rebuild, and upload the updated `docs/` folder. Browser searches are not saved.

## Original server-hosted version

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
migrations. `db/seed.sql` contains the 212 stations, 11 trains, and their stops.
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
