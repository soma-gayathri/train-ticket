import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync, existsSync, readdirSync } from 'node:fs';

test('frontend ships API assets without a browser database or engine', () => {
  const html = readFileSync('frontend/index.html', 'utf8');
  assert.match(html, /src="\.\/bootstrap\.js\?v=[a-f0-9]{12}"/);
  for (const match of html.matchAll(/(?:src|href)="\.\/([^"?]+)(?:\?[^" ]*)?"/g)) {
    assert.ok(existsSync('frontend/'+match[1]), match[1]);
  }
  assert.deepEqual(JSON.parse(readFileSync('frontend/config.json', 'utf8')), {dataSource:'api',apiBaseUrl:''});
  const bootstrap = readFileSync('frontend/bootstrap.js', 'utf8');
  assert.match(bootstrap, /from '\.\/api-client\.js\?v=[a-f0-9]{12}'/);
  assert.ok(bootstrap.includes('createApiDataSource()'));
  assert.ok(!readdirSync('frontend').some(file => ['data','vendor','db','pages'].includes(file)));
  assert.ok(!html.includes('sql-wasm'));
});
