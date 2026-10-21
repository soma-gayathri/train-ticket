import test from 'node:test';
import assert from 'node:assert/strict';
import { DatabaseSync } from 'node:sqlite';
import { readFileSync, readdirSync } from 'node:fs';
import { listStations, searchJourneys } from '../db/repository.js';

function setup() {
  const sqlite = new DatabaseSync(':memory:');
  sqlite.exec('PRAGMA foreign_keys = ON');
  for (const file of readdirSync('drizzle').filter(f=>f.endsWith('.sql')).sort()) sqlite.exec(readFileSync(`drizzle/${file}`,'utf8'));
  const seed = readFileSync('db/seed.sql','utf8');
  sqlite.exec(seed);
  const adapter = {
    prepare(sql) {
      let args=[];
      return {bind(...values){args=values;return this;},async all(){return {results:sqlite.prepare(sql).all(...args)};}};
    }
  };
  return {sqlite, adapter, seed};
}

test('schema and seed preserve all records and seed is repeatable',async()=>{
  const {sqlite,adapter,seed}=setup();
  assert.equal((await listStations(adapter)).length,212);
  assert.equal(sqlite.prepare('SELECT count(*) AS n FROM trains').get().n,97);
  const before=sqlite.prepare('SELECT count(*) AS n FROM train_stops').get().n;
  sqlite.exec(seed);
  assert.equal(sqlite.prepare('SELECT count(*) AS n FROM train_stops').get().n,before);
  assert.equal(sqlite.prepare('PRAGMA foreign_key_check').all().length,0);
  assert.throws(()=>sqlite.prepare("INSERT INTO train_stops VALUES ('missing',0,'NDLS',NULL,'10:00',0,0)").run());
  sqlite.close();
});
test('SQL search respects route order and returns only the selected segment',async()=>{
  const {sqlite,adapter}=setup();
  assert.equal((await searchJourneys(adapter,'NDLS','JP')).length,3);
  const found=await searchJourneys(adapter,'GGN','AWR');
  assert.equal(found.length,3);
  assert.deepEqual(found.find(t=>t.number==='12015').segment.map(s=>s.code),['GGN','RE','AWR']);
  assert.equal((await searchJourneys(adapter,'JP','NDLS')).length,1);
  assert.equal((await searchJourneys(adapter,'NDLS','SBC')).length,0);
  sqlite.close();
});
test('overnight and intermediate journeys calculate relative days correctly',async()=>{
  const {sqlite,adapter}=setup();
  const overnight=(await searchJourneys(adapter,'SBC','MAS')).find(t=>t.number==='12658');
  assert.equal(overnight.duration,360);assert.equal(overnight.dayDifference,1);
  const segment=(await searchJourneys(adapter,'KPD','MAS')).find(t=>t.number==='12658');
  assert.equal(segment.duration,120);assert.equal(segment.dayDifference,0);
  sqlite.close();
});
test('invalid, identical, unknown, and SQL-injection station inputs are rejected',async()=>{
  const {sqlite,adapter}=setup();
  for(const [a,b] of [['','JP'],['NDLS','NDLS'],['ZZZZ','JP'],["NDLS' OR 1=1 --",'JP']])await assert.rejects(searchJourneys(adapter,a,b));
  assert.equal(sqlite.prepare('SELECT count(*) AS n FROM trains').get().n,97);
  sqlite.close();
});
test('queries reflect database changes rather than a browser-side dataset',async()=>{
  const {sqlite,adapter}=setup();
  sqlite.prepare("UPDATE trains SET name='Updated train name' WHERE number='12015'").run();
  assert.equal((await searchJourneys(adapter,'NDLS','JP')).find(t=>t.number==='12015').name,'Updated train name');
  sqlite.close();
});

test('regional samples cover every station with valid forward and return schedules', async()=>{
  const {sqlite,adapter}=setup();
  assert.equal(sqlite.prepare('SELECT count(*) AS n FROM stations p WHERE NOT EXISTS (SELECT 1 FROM train_stops s WHERE s.station_code=p.code AND s.departure IS NOT NULL)').get().n,0);
  assert.equal(sqlite.prepare('SELECT count(*) AS n FROM stations p WHERE NOT EXISTS (SELECT 1 FROM train_stops s WHERE s.station_code=p.code AND s.arrival IS NOT NULL)').get().n,0);
  const journey=(await searchJourneys(adapter,'AD','BNC')).find(t=>t.number==='90001');
  assert.deepEqual(journey.segment.map(s=>s.code),['AD','YNK','YPR','SBC','BNC']);
  assert.equal(journey.duration,405);
  assert.ok((await searchJourneys(adapter,'BNC','AD')).length>0);
  const minutes=(time,day)=>day*1440+Number(time.slice(0,2))*60+Number(time.slice(3));
  for(const train of sqlite.prepare("SELECT number FROM trains WHERE type='Demo Express'").all()){
    let previous=-1;
    for(const stop of sqlite.prepare('SELECT * FROM train_stops WHERE train_number=? ORDER BY stop_order').all(train.number)){
      if(stop.arrival!==null){const arrival=minutes(stop.arrival,stop.arrival_day);assert.ok(arrival>previous,train.number);previous=arrival;}
      if(stop.departure!==null){const departure=minutes(stop.departure,stop.departure_day);assert.ok(departure>=previous,train.number);previous=departure;}
    }
  }
  sqlite.close();
});
