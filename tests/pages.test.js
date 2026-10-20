import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync, existsSync } from 'node:fs';
import initSqlJs from 'sql.js';
import { createDataSource, sqliteAdapter } from '../pages/database.js';

test('Pages output contains a real SQLite database and all engine assets', async () => {
  const bytes = readFileSync('docs/data/railway.sqlite');
  assert.equal(bytes.subarray(0, 16).toString(), 'SQLite format 3\0');
  const SQL = await initSqlJs(); const database = new SQL.Database(bytes);
  for (const [table, count] of [['stations',212],['trains',11],['train_stops',69]]) assert.equal(database.exec(`SELECT COUNT(*) FROM ${table}`)[0].values[0][0], count);
  assert.equal(database.exec('PRAGMA foreign_key_check').length, 0);
  database.close();
  assert.ok(existsSync('docs/vendor/sql-wasm.js')); assert.ok(existsSync('docs/vendor/sql-wasm.wasm'));
  assert.ok(!existsSync('docs/schedules.js'));
  const html = readFileSync('docs/index.html','utf8');
  assert.ok(html.includes('src="./pages/bootstrap.js"'));
  assert.ok(!readFileSync('docs/styles.css','utf8').includes('fonts.googleapis.com'));
});

test('browser SQLite transport finds routes and shares a single database load', async () => {
  let loads=0;
  const read = createDataSource({initSqlJs, wasmUrl:undefined, fetchDatabase:async()=>{loads++;return readFileSync('docs/data/railway.sqlite');}});
  assert.equal((await read('/api/stations')).stations.length,212);
  const direct=await read('/api/trains?from=NDLS&to=JP'); assert.equal(direct.trains.length,3);
  const middle=await read('/api/trains?from=GGN&to=AWR'); assert.deepEqual(middle.trains[0].segment.map(s=>s.code),['GGN','RE','AWR']);
  assert.equal((await read('/api/trains?from=JP&to=NDLS')).trains.length,1);
  assert.equal((await read('/api/trains?from=NDLS&to=SBC')).trains.length,0);
  const overnight=(await read('/api/trains?from=SBC&to=MAS')).trains.find(t=>t.number==='12658');
  assert.equal(overnight.duration,360); assert.equal(overnight.dayDifference,1);
  assert.equal(loads,1);
  await assert.rejects(read('/api/trains?from=NDLS&to=NDLS'));
  await assert.rejects(read('/api/trains?from=unknown&to=JP'));
  const controller = new AbortController(); controller.abort();
  await assert.rejects(read('/api/stations',controller.signal),{name:'AbortError'});
});

test('database load failures can be retried', async () => {
  let loads=0;
  const read=createDataSource({initSqlJs,wasmUrl:undefined,fetchDatabase:async()=>{if(++loads===1)throw new Error('offline');return readFileSync('docs/data/railway.sqlite');}});
  await assert.rejects(read('/api/stations'),/offline/);
  assert.equal((await read('/api/stations')).stations.length,212);
});

test('database snapshot is read-only', async () => {
  const SQL=await initSqlJs();const database=new SQL.Database(readFileSync('docs/data/railway.sqlite'));
  database.run('PRAGMA query_only = ON');
  await assert.rejects(sqliteAdapter(database).prepare('DELETE FROM stations').all(),/readonly/);
  database.close();
});
