import test from 'node:test';
import assert from 'node:assert/strict';
import { createApiDataSource } from '../public/api-client.js';
import { formatFare, renderExtras } from '../public/train-features.js';

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
