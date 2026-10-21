# Java backend and database

This Spring Boot 4.1.1 / Java 17 service implements read-only station search,
train search, details, full schedules, and sample fare calculation. Booking,
cancellation, payments, user accounts, and real seat availability are not included.

## Run locally

From the project root, install the existing frontend dependencies if needed,
then build the browser assets:

```
npm run build:pages
cd backend
```

On Windows:

```
.\mvnw.cmd verify
java -jar target/railway-api-0.0.1-SNAPSHOT.jar
```

On macOS/Linux use `./mvnw verify`. The Maven wrapper downloads Maven on its
first run; no global Maven installation is required. Java 17 or newer is required.

Open http://localhost:8080. The JAR serves the frontend and API together. Its
`config.json` selects API mode, so this page reads the Java database rather than
the browser snapshot. The default listener is loopback only.

The local database is persistent H2 at `backend/data/railway.mv.db` when launched
from `backend/`. Run from that directory consistently. It survives restarts and
is excluded from Git. `src/main/resources/db/migration/V1__railway_schema.sql`
creates four tables with Flyway:

| Table | Records initially | Contents |
| --- | ---: | --- |
| stations | 212 | Station codes and names |
| trains | 11 | Train numbers, names, categories |
| train_stops | 69 | Ordered station references and arrival/departure day offsets |
| fare_rules | 4 | Sample base fares and per-leg prices for SL, 3A, 2A, CC |

Startup seeds an empty database transactionally from the shared `../db/seed.sql`
resource. It does not overwrite an existing non-empty database. Seed changes
must be applied deliberately to an existing database. Applied Flyway migrations
are immutable; append a migration for later schema changes.

## API

| Method and path | Response |
| --- | --- |
| `GET /api/health` | Service health |
| `GET /api/stations?q=C` | Station name/code prefix matches; omit q for all stations |
| `GET /api/trains?from=NDLS&to=JP` | Matching journey segments, times, duration, relative arrival day |
| `GET /api/trains/12015` | Train details and full route |
| `GET /api/trains/12015/schedule` | Full ordered stop list and station names |
| `GET /api/trains/12015/fare?from=NDLS&to=JP&travelClass=SL&passengers=2` | Sample price, integer paise, currency and disclaimer |

Train searches retain the same JSON shape as the existing frontend. Invalid
inputs return 400, unknown trains 404, database failures 503. Error responses
include an `error` message. SQL user inputs are bound parameters.

Sample fares use `base_paise + per_leg_paise × (selected stops - 1)`, multiplied
by 1–6 passengers. Money is calculated as integer paise, avoiding floating-point
rounding. These are not distance-based or verified railway fares and do not
assert that a real train offers the selected class.

## Connect a separately hosted frontend

The GitHub Pages build defaults to browser SQLite to keep the public website
usable without a backend host. To connect it to a deployed Java service, edit
`public/config.json`, then rebuild and publish `docs/`:

```json
{
  "dataSource": "api",
  "apiBaseUrl": "https://YOUR-JAVA-BACKEND-HOST"
}
```

Use the service origin, not an `/api` suffix. The frontend appends API paths.
For a local standalone frontend use an HTTP localhost backend, for example
`http://localhost:8080`. An HTTPS GitHub Pages frontend requires an HTTPS backend.
Never put passwords, tokens, or database URLs in this public JSON file.

Set `CORS_ORIGINS` on the backend to a comma-separated list of allowed frontend
origins. The existing GitHub Pages origin and local preview origins are allowed
by default. A GitHub project path is not part of its origin:
`https://soma-gayathri.github.io` is correct. Failed API requests show an error;
the frontend does not silently switch to SQLite.

GitHub Pages serves static files and cannot execute a JVM or run the shared
database. The Spring Boot backend must run locally or on a Java/container host.

## PostgreSQL / container deployment

The same application supports PostgreSQL through environment variables:

| Variable | Default / purpose |
| --- | --- |
| `DB_URL` | Local H2 URL; use `jdbc:postgresql://HOST:5432/railway` for PostgreSQL |
| `DB_USERNAME` | `sa` locally; PostgreSQL database username when deployed |
| `DB_PASSWORD` | Empty for local H2; set a secret database password for PostgreSQL |
| `CORS_ORIGINS` | Allowed frontend origins |
| `SERVER_ADDRESS` | `127.0.0.1` locally; `0.0.0.0` in the container |
| `PORT` | 8080 |

With Docker running, set `DB_PASSWORD` in your shell and run from `backend/`:

```
docker compose -f compose.yml up --build
```

The compose file starts PostgreSQL with a persistent named volume, waits for
database readiness, and starts the API. PostgreSQL has no public host port.
The API is exposed on localhost:8080. Production hosts must provide their own
HTTPS endpoint and managed secret values. The image runs as a non-root user.

## Tests

`mvnw verify` runs real HTTP integration tests against isolated H2 memory
storage, covering data initialization, queries, schedules, overnight durations,
fares, invalid input, unknown trains, CORS, and frontend API configuration.
`npm test` from the project root covers the browser SQLite mode and API client.
