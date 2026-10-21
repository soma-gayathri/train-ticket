# Railway train search

One Spring Boot application serves the website and Java APIs. Train data stays
in the server database; the browser calls /api/... on the same website origin.
GitHub stores the source code. GitHub Pages and browser SQLite are no longer
part of this application.

## Run the website

Use Node 22.13+ and Java 17+. From this directory:

```powershell
npm ci
npm run build:frontend
npm test
cd backend
.\mvnw.cmd clean verify
java -jar target/railway-api-0.0.1-SNAPSHOT.jar
```

On macOS/Linux use ./mvnw clean verify. Open http://localhost:8080.
Keep the Java process running while using the website.

The frontend build is committed in frontend/ and bundled into the Java JAR.
Rebuild it after editing public/ files or the HTML in app/page.tsx, then
repackage the backend. Frontend assets have versioned URLs for browser updates.
There is no browser database download or fallback to local sample queries.

## Features and data

Search stations, find trains in travel order, expand selected journey stops,
view full train details and schedules, and calculate sample fares. All times
and fares are illustrative samples. Booking and cancellation are not included.

| Table | Initial records | Contents |
| --- | ---: | --- |
| stations | 212 | Station codes and names |
| trains | 97 | Train numbers, names and categories |
| train_stops | 673 | Ordered stops, times and day offsets |
| fare_rules | 4 | Sample fare calculation rules |

The local database is backend/data/railway.mv.db when the application is
started from backend/. It survives restarts and is excluded from Git.
db/seed.sql supplies initial sample data. Startup seeds an empty database;
editing the seed does not overwrite existing database records.

See [backend/README.md](backend/README.md) for API routes, database migration
instructions, PostgreSQL configuration, and container deployment. To publish
online, deploy the Java application with persistent storage or PostgreSQL and
an HTTPS endpoint. The deployed application supplies one URL for frontend and API.

## Tests and older source

npm test checks frontend assets, autocomplete, API transport, fare display,
and shared seed/query regressions. mvnw clean verify tests real Java HTTP
endpoints and the packaged frontend using isolated H2 storage.

The older app/api, Drizzle, and Cloudflare tooling are retained as source
history and are not used by the Spring Boot runtime. The active server schema
is maintained in backend/src/main/resources/db/migration/.

The regional demo dataset includes 86 fictional services in both directions,
covering every one of the 212 directory stations. Not every station pair has
a direct service. Names, numbers, routes, and times are illustrative only.
Flyway V2 adds these records to existing databases without replacing existing
records. No database reset is needed. Later data changes need a new migration;
do not regenerate an applied V2 migration.
