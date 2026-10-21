import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import initSqlJs from 'sql.js';
import { createDataSource } from '../pages/database.js';
import { createApiDataSource } from '../public/api-client.js';
import { formatFare, renderExtras } from '../public/train-features.js';

const read = createDataSource({initSqlJs,fetchDatabase:async()=>readFileSync('docs/data/railway.sqlite')});
test('details and schedule read the whole train route from SQLite',async()=>{
  const details=await read('/api/trains/12015'); const schedule=await read('/api/trains/12015/schedule');
  assert.equal(details.number,'12015'); assert.equal(details.sample,true); assert.equal(schedule.stops.length,9);
  assert.equal(schedule.stops[0].code,'NDLS'); assert.equal(schedule.stops.at(-1).code,'AII');
});
test('sample fare rules apply to selected legs and passenger count',async()=>{
  const quote=await read('/api/trains/12015/fare?from=NDLS&to=JP&travelClass=SL&passengers=2');
  assert.equal(quote.unitFarePaise,19000); assert.equal(quote.totalFarePaise,38000); assert.equal(quote.sample,true);
  assert.equal((await read('/api/trains/12015/fare?from=GGN&to=AWR')).totalFarePaise,9000);
  for(const query of ['passengers=0','passengers=7','passengers=1.5','travelClass=BAD'])await assert.rejects(read('/api/trains/12015/fare?from=NDLS&to=JP&'+query));
  await assert.rejects(read('/api/trains/12015/fare?from=JP&to=NDLS'));
  await assert.rejects(read('/api/trains/99999'));
});
test('API transport builds the configured URL and exposes backend errors',async()=>{
  let requested;
  const api=createApiDataSource('http://localhost:8080/',async(url,options)=>{requested=url;assert.equal(options.cache,'no-store');return {ok:true,json:async()=>({stations:[]})};});
  assert.deepEqual(await api('/api/stations'),{stations:[]}); assert.equal(requested,'http://localhost:8080/api/stations');
  const failed=createApiDataSource('',async()=>({ok:false,status:400,json:async()=>({error:'Choose a station.'})}));
  await assert.rejects(failed('/api/trains'),/Choose a station/);
  const network=createApiDataSource('',async()=>{throw new TypeError('network');});await assert.rejects(network('/api/stations'),/Could not reach the backend/);
  assert.throws(()=>createApiDataSource('ftp://example.com'),/HTTP/);
  assert.throws(()=>createApiDataSource('https://user:password@example.com'),/credentials/);
});
test('fare display and result controls clearly identify sample pricing',()=>{
  assert.ok(formatFare(19000).includes('190')); assert.throws(()=>formatFare(-1));
  const html=renderExtras({number:'12015',departure:{code:'NDLS'},arrival:{code:'JP'}});
  for(const label of ['Train details','Full train schedule','Calculate sample fare'])assert.ok(html.includes(label));
  assert.ok(html.includes('not check real fares'));
});
