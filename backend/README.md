# Java backend with MySQL

The Spring Boot / Java 17 application serves the frontend and read-only APIs
from one server. MySQL is the application database. H2 is only a test dependency
and is not included in the application JAR.

## Start on Windows

MySQL Server 8.0.16+ (or 8.4) must be running. From the project root:

```powershell
npm run build:frontend
cd backend
.\start-mysql.ps1
```

The script uses username root and database railway, asks privately for your
password, creates the database if missing, builds/tests the application, and
starts the website at http://localhost:8080. It finds mysql.exe on PATH or in
the standard Windows MySQL installation folder. Passwords are supplied only
through the current process environment and restored when the script exits.
Do not put real passwords in source files or commit them.

To use another user or server:

```powershell
.\start-mysql.ps1 -DbUser railway -DbHost localhost -DbPort 3306 -DbName railway
```

For deployment, use an application-specific MySQL account rather than root.

## Forgotten local MySQL password

For the standard Windows MySQL80 service, run reset-mysql-password.ps1 from
an Administrator PowerShell window. It asks for a new password twice, uses a
temporary init-file to reset root@localhost, verifies the new login, restores
the original server configuration, and restarts the normal service. Databases
are preserved. The temporary password SQL is access-restricted and deleted;
the password is never written to this repository or printed. MySQL will be
briefly unavailable. Other applications using root need the new password.

Then run start-mysql.ps1 using the new password. The procedure follows the
[MySQL Windows password-reset instructions](https://dev.mysql.com/doc/refman/8.0/en/resetting-permissions.html).

## Connection settings

| Environment variable | Default / purpose |
| --- | --- |
| DB_URL | jdbc:mysql://localhost:3306/railway |
| DB_USERNAME | root |
| DB_PASSWORD | Required; your MySQL password |
| SERVER_ADDRESS | 127.0.0.1 locally; 0.0.0.0 for a hosted container |
| PORT | 8080 |
| CORS_ORIGINS | Allowed frontend origins; the bundled frontend shares the API origin |

For a manual launch, create the database using mysql-setup.sql in MySQL
Workbench, supply the three DB environment variables, then run:

```
./mvnw clean verify
java -jar target/railway-api-0.0.1-SNAPSHOT.jar
```

On Windows the Maven command is .\mvnw.cmd clean verify. The wrapper downloads
Maven and dependencies on first use. The JAR bundles ../frontend/; rebuild those
assets before packaging after frontend changes. No separate frontend host is needed.

## Tables and sample data

Flyway runs SQL in src/main/resources/db/mysql/ automatically:

- V1__railway_schema.sql creates the InnoDB tables, foreign keys, and indexes.
- V2__sample_route_coverage.sql inserts the complete sample dataset.

| Table | Initial records | Contents |
| --- | ---: | --- |
| stations | 212 | Station names and codes |
| trains | 97 | Train names, numbers and categories |
| train_stops | 673 | Ordered stops, timings and day offsets |
| fare_rules | 4 | Sample prices for SL, 3A, 2A and CC |

Applied migrations are immutable. Add a new migration for later schema or data
changes. Do not manually import db/seed.sql into MySQL: that file is the legacy
SQLite-format seed used by data regression tests. The MySQL migration is the
runtime data source. Existing MySQL records are not replaced by the sample inserts.

The old H2 file at data/railway.mv.db is left untouched. This change creates a
new MySQL database populated with the shared sample dataset; it does not transfer
custom edits from H2 automatically. Backups of hosted MySQL data are separate
from Git source code.

## API

| GET endpoint | Purpose |
| --- | --- |
| /api/health | Service health |
| /api/stations?q=C | Station prefix search; omit q for all stations |
| /api/trains?from=AD&to=BNC | Directional train search |
| /api/trains/90001 | Train details and full route |
| /api/trains/90001/schedule | Ordered stop list |
| /api/trains/90001/fare?from=AD&to=BNC&travelClass=SL&passengers=2 | Sample fare |

Invalid inputs return 400, missing trains 404, and database errors 503. SQL
inputs use bound parameters. Sample fares use integer paise and scheduled legs,
not verified distance or railway fares. Booking/cancellation are not implemented.
All additional demo routes and timings are fictional, and some station pairs
have no direct sample service.

## Containers

With Docker running, set DB_PASSWORD (application user) and MYSQL_ROOT_PASSWORD
(separate administrator secret), then run from backend/:

```
docker compose up --build
```

Compose starts MySQL 8.4 with a persistent railway-mysql volume and a separate
railway application user, waits for database readiness, then starts the Java
application on localhost:8080. MySQL has no exposed host port. The old PostgreSQL
volume is not reused or deleted. An online host must supply HTTPS and persistent
MySQL storage; do not rely on an ephemeral container filesystem for database data.

## Tests

npm test in the project root checks frontend and shared data regressions.
The default Maven suite uses isolated H2 memory databases for fast API and
migration regression tests; it does not prove a real MySQL connection.

To run the additional real-MySQL HTTP and foreign-key tests, create a dedicated
empty railway_test database and set MYSQL_TEST_URL to
jdbc:mysql://localhost:3306/railway_test, MYSQL_TEST_USERNAME to root (or a test
user), and MYSQL_TEST_PASSWORD privately. Then run .\mvnw.cmd verify. Without
MYSQL_TEST_URL those MySQL-specific tests are explicitly skipped. Do not use
your application database as the test database.
