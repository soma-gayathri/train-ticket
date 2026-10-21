# Railway train search

One Spring Boot application serves the website and Java APIs. Train data stays
in the server database; the browser calls /api/... on the same website origin.
GitHub stores the source code. GitHub Pages and browser SQLite are no longer
part of this application.

## Run the website

Use Node 22.13+, Java 17+, and a running MySQL 8.0.16+ server. From this directory:

```powershell
npm ci
npm run build:frontend
npm test
cd backend
.\start-mysql.ps1
```

The script asks privately for your MySQL root password, creates the railway
database if missing, builds the app, and starts it. Open http://localhost:8080.
For other systems or a preconfigured server, see backend/README.md.
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

The application uses MySQL database railway on localhost:3306 with username
root by default. Credentials are supplied through server environment variables.
Flyway creates the tables and inserts sample data from db/mysql migrations at
startup. The old backend/data/railway.mv.db file is preserved but is no longer
used; custom edits in that H2 database are not automatically transferred.

See [backend/README.md](backend/README.md) for API routes, database migration
instructions, MySQL configuration, and container deployment. To publish
online, deploy the Java application with persistent storage or MySQL and
an HTTPS endpoint. The deployed application supplies one URL for frontend and API.

## Tests and older source

npm test checks frontend assets, autocomplete, API transport, fare display,
and shared seed/query regressions. mvnw clean verify tests real Java HTTP
endpoints and the packaged frontend using isolated H2 storage.

The older app/api, Drizzle, and Cloudflare tooling are retained as source
history and are not used by the Spring Boot runtime. The active server schema
is maintained in backend/src/main/resources/db/mysql/.

The regional demo dataset includes 86 fictional services in both directions,
covering every one of the 212 directory stations. Not every station pair has
a direct service. Names, numbers, routes, and times are illustrative only.
Flyway V2 adds these records to existing databases without replacing existing
records. No database reset is needed. Later data changes need a new migration;
do not regenerate an applied V2 migration.
