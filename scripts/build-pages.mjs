import { readFileSync, writeFileSync, mkdirSync, copyFileSync, readdirSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import initSqlJs from 'sql.js';
import { createHash } from 'node:crypto';

const root = fileURLToPath(new URL('../', import.meta.url));
const output = path.join(root, 'docs');
for (const folder of ['', 'vendor', 'data', 'pages', 'db']) mkdirSync(path.join(output, folder), { recursive: true });

const SQL = await initSqlJs();
const database = new SQL.Database();
database.run('PRAGMA foreign_keys = ON');
for (const file of readdirSync(path.join(root, 'drizzle')).filter(f => f.endsWith('.sql')).sort()) {
  database.run(readFileSync(path.join(root, 'drizzle', file), 'utf8'));
}
database.run(readFileSync(path.join(root, 'db/seed.sql'), 'utf8'));
if (database.exec('PRAGMA foreign_key_check').length) throw new Error('Invalid database references');
const counts = Object.fromEntries(['stations', 'trains', 'train_stops'].map(table => [table, database.exec(`SELECT COUNT(*) FROM ${table}`)[0].values[0][0]]));
writeFileSync(path.join(output, 'data/railway.sqlite'), database.export());
database.close();

for (const file of ['sql-wasm.js', 'sql-wasm.wasm']) copyFileSync(path.join(root, 'node_modules/sql.js/dist', file), path.join(output, 'vendor', file));
copyFileSync(path.join(root, 'node_modules/sql.js/LICENSE'), path.join(output, 'vendor/sql.js-LICENSE.txt'));
for (const file of ['database.js', 'bootstrap.js']) copyFileSync(path.join(root, 'pages', file), path.join(output, 'pages', file));
copyFileSync(path.join(root, 'db/repository.js'), path.join(output, 'db/repository.js'));
copyFileSync(path.join(root, 'public/app.js'), path.join(output, 'app.js'));
copyFileSync(path.join(root, 'public/station-autocomplete.js'), path.join(output, 'station-autocomplete.js'));
copyFileSync(path.join(root, 'public/api-client.js'), path.join(output, 'api-client.js'));
copyFileSync(path.join(root, 'public/config.json'), path.join(output, 'config.json'));
copyFileSync(path.join(root, 'public/train-features.js'), path.join(output, 'train-features.js'));
// Use system-font fallbacks so the GitHub Pages version has no external CDN requests.
writeFileSync(path.join(output, 'styles.css'), readFileSync(path.join(root, 'public/styles.css'), 'utf8').replace(/@import\s+url\([^;]+;/g, ''));

const page = readFileSync(path.join(root, 'app/page.tsx'), 'utf8');
const match = page.match(/__html:\s*("(?:[^"\\]|\\.)*")/);
if (!match) throw new Error('Could not find the page markup');
const body = JSON.parse(match[1]);
const hash = createHash('sha256');
for (const file of ['data/railway.sqlite','app.js','station-autocomplete.js','api-client.js','train-features.js','config.json','pages/bootstrap.js','pages/database.js','db/repository.js','styles.css']) hash.update(readFileSync(path.join(output,file)));
const release = hash.digest('hex').slice(0,12);
writeFileSync(path.join(output, 'index.html'), `<!doctype html>\n<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="description" content="Search sample Indian train schedules stored in a SQLite database, entirely on GitHub Pages."><title>Railway — Find your next journey</title><link rel="stylesheet" href="./styles.css?v=${release}"></head><body>${body}<script src="./vendor/sql-wasm.js"></script><script type="module" src="./pages/bootstrap.js?v=${release}"></script></body></html>\n`);
writeFileSync(path.join(output, '.nojekyll'), '');
console.log(JSON.stringify({ output, tables: counts, hosting: 'GitHub Pages only' }));
