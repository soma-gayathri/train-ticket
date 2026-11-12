import { readFileSync, writeFileSync, mkdirSync, copyFileSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { createHash } from 'node:crypto';

const root = fileURLToPath(new URL('../', import.meta.url));
// GitHub Pages can publish this directory directly from the main branch.
const output = path.join(root, 'docs');
mkdirSync(output, { recursive: true });
const assets = ['app.js', 'station-autocomplete.js', 'api-client.js', 'bootstrap.js', 'train-features.js', 'auth.js', 'config.json'];
for (const file of assets) copyFileSync(path.join(root, 'public', file), path.join(output, file));
writeFileSync(path.join(output, 'styles.css'), readFileSync(path.join(root, 'public/styles.css'), 'utf8').replace(/@import\s+url\([^;]+;/g, ''));

const page = readFileSync(path.join(root, 'frontend/index.html'), 'utf8');
const match = page.match(/<body>([\s\S]*?)<script type="module"[\s\S]*?<\/script><\/body>/);
if (!match) throw new Error('Could not find the page markup');
const body = match[1];
const hash = createHash('sha256');
hash.update(readFileSync(fileURLToPath(import.meta.url)));
hash.update(body);
for (const file of [...assets, 'styles.css']) hash.update(readFileSync(path.join(output, file)));
const release = hash.digest('hex').slice(0, 12);
const bootstrap = path.join(output, 'bootstrap.js');
writeFileSync(bootstrap, readFileSync(bootstrap, 'utf8').replace("from './api-client.js'", `from './api-client.js?v=${release}'`));
writeFileSync(path.join(output, 'index.html'), `<!doctype html>\n<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="description" content="Search sample Indian train schedules, stops and fares."><title>Railway — Find your next journey</title><link rel="stylesheet" href="./styles.css?v=${release}"></head><body>${body}<script type="module" src="./bootstrap.js?v=${release}"></script></body></html>\n`);
const loginTemplate = readFileSync(path.join(root, 'frontend/login.html'), 'utf8');
writeFileSync(path.join(output, 'login.html'), loginTemplate.replaceAll('__RELEASE__', release));
console.log(`Built GitHub Pages frontend: ${output}`);
