// Run only when authoring a NEW data migration. Never regenerate an applied migration.
import { DatabaseSync } from 'node:sqlite';
import { readFileSync, writeFileSync, readdirSync, existsSync } from 'node:fs';

const migration = 'backend/src/main/resources/db/migration/V2__sample_route_coverage.sql';
const mysqlMigration = 'backend/src/main/resources/db/mysql/V2__sample_route_coverage.sql';
if (existsSync(migration) || existsSync(mysqlMigration)) throw new Error('V2 already exists. Applied migrations are immutable; create a new migration for later data changes.');
const marker = '\n-- Additional fictional regional demo services.\n';
const seed = readFileSync('db/seed.sql','utf8').split(marker)[0];
const db = new DatabaseSync(':memory:');
for (const file of readdirSync('drizzle').filter(f=>f.endsWith('.sql')).sort()) db.exec(readFileSync('drizzle/'+file,'utf8'));
db.exec(seed);
const names = new Map(db.prepare('SELECT code, name FROM stations').all().map(s=>[s.code,s.name]));
const routes = JSON.parse(readFileSync('db/sample-routes.json','utf8'));
const quote = value => value === null ? 'NULL' : typeof value === 'number' ? String(value) : "'"+value.replaceAll("'","''")+"'";
let extra = '';
let number = 90001;
const covered = new Set();
for (const route of routes) {
  const codes = route.stops.split(' ');
  if (new Set(codes).size !== codes.length) throw new Error('Repeated station in '+route.name);
  for (const code of codes) { if (!names.has(code)) throw new Error('Unknown station '+code); covered.add(code); }
  const legs = route.minutes ?? codes.slice(1).map((_,i)=>90+(i%3)*30);
  if (legs.length !== codes.length-1 || legs.some(n=>!Number.isInteger(n)||n<=0)) throw new Error('Invalid travel times');
  for (const reverse of [false,true]) {
    const id = String(number++);
    const stops = reverse ? [...codes].reverse() : codes;
    const times = reverse ? [...legs].reverse() : legs;
    const label = `Demo ${route.name} ${reverse?'Return':'Express'}`;
    extra += `INSERT OR IGNORE INTO trains (number,name,type) VALUES (${quote(id)},${quote(label)},'Demo Express');\n`;
    let clock = reverse ? 18*60 : 6*60;
    const time = value => `'${String(Math.floor(value/60)%24).padStart(2,'0')}:${String(value%60).padStart(2,'0')}'`;
    for (let i=0;i<stops.length;i++) {
      const arrival = i===0 ? 'NULL' : time(clock);
      const arrivalDay = Math.floor(clock/1440);
      if (i>0 && i<stops.length-1) clock += 5;
      const departure = i===stops.length-1 ? 'NULL' : time(clock);
      extra += `INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES (${quote(id)},${i},${quote(stops[i])},${arrival},${departure},${arrivalDay},${Math.floor(clock/1440)});\n`;
      if (i<times.length) clock += times[i];
    }
  }
}
const missing = [...names.keys()].filter(code=>!covered.has(code));
if (missing.length) throw new Error('Uncovered stations: '+missing.join(', '));
db.exec(extra);
if (db.prepare('PRAGMA foreign_key_check').all().length) throw new Error('Invalid foreign keys');
// Portable conditional inserts work on H2 and MySQL. Include base rows so
// a fresh database and an existing installation both receive the complete data.
let portable = '-- Fictional sample routes, not verified railway services. Adds data without replacing existing records.\n';
const keys = {stations:['code'],trains:['number'],train_stops:['train_number','stop_order'],fare_rules:['travel_class']};
for (const table of ['stations','trains','train_stops','fare_rules']) {
  for (const row of db.prepare('SELECT * FROM '+table).all()) {
    const columns = Object.keys(row);
    portable += `INSERT INTO ${table} (${columns.join(',')}) SELECT ${columns.map(c=>quote(row[c])).join(',')} WHERE NOT EXISTS (SELECT 1 FROM ${table} WHERE ${keys[table].map(c=>c+' = '+quote(row[c])).join(' AND ')});\n`;
  }
}
writeFileSync('db/seed.sql',seed+marker+extra);
writeFileSync(migration,portable);
writeFileSync(mysqlMigration,portable);
console.log({addedTrains:number-90001,coveredStations:covered.size,trains:db.prepare('SELECT count(*) AS n FROM trains').get().n,stops:db.prepare('SELECT count(*) AS n FROM train_stops').get().n});
db.close();
