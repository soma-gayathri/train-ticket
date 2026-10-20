import test from 'node:test';
import assert from 'node:assert/strict';
import { DatabaseSync } from 'node:sqlite';
import { readFileSync } from 'node:fs';
import { matchingStations, resolveStation } from '../public/station-autocomplete.js';

const database = new DatabaseSync('docs/data/railway.sqlite', {readOnly:true});
const stations = database.prepare('SELECT code, name FROM stations').all();
database.close();
const codes = query => matchingStations(stations,query).map(s=>s.code);

test('letter prefixes include popular A, B, K and Z places',()=>{
  for (const code of ['ADI','AGC','AII','ASR']) assert.ok(codes('a').includes(code),code);
  for (const code of ['SBC','BNC','BPL','BBS']) assert.ok(codes('B').includes(code),code);
  for (const code of ['HX','KRMR','CNB','KOAA','KPD']) assert.ok(codes('k').includes(code),code);
  assert.ok(codes('Z').includes('ZB'));
});
test('typed prefixes narrow suggestions and matching is case-insensitive',()=>{
  assert.deepEqual(codes(' kad '),['HX']);
  assert.ok(codes('KARIM').includes('KRMR'));
  assert.ok(codes('ahme').includes('ADI'));
  assert.deepEqual(codes('zzzzzz'),[]);
  assert.equal(codes('').length,stations.length);
});
test('common and former city names resolve to valid station records',()=>{
  assert.equal(resolveStation(stations,'Bangalore').code,'SBC');
  assert.equal(resolveStation([...stations].reverse(),'Bangalore').code,'SBC');
  assert.ok(codes('Bengaluru').includes('SBC'));
  assert.ok(codes('Bombay').includes('BCT'));
  assert.ok(codes('Calcutta').includes('KOAA'));
  assert.equal(resolveStation(stations,'Kadapa (HX)').code,'HX');
  assert.equal(resolveStation(stations,'krmr').code,'KRMR');
  assert.equal(resolveStation(stations,'not a station'),undefined);
});
test('the published app includes the autocomplete module',()=>{
  assert.equal(readFileSync('docs/station-autocomplete.js','utf8'),readFileSync('public/station-autocomplete.js','utf8'));
  assert.ok(readFileSync('docs/app.js','utf8').includes("import('./station-autocomplete.js')"));
});
