import { createDataSource } from './database.js';
import { createApiDataSource } from '../api-client.js';

const release = new URL(import.meta.url).searchParams.get('v');
globalThis.railwayAssetVersion = release;
function versionedUrl(path) {
  const url = new URL(path, import.meta.url);
  if (release) url.searchParams.set('v',release);
  return url;
}

const sqliteDataSource = createDataSource({
  initSqlJs: options => {
    if (!globalThis.initSqlJs) throw new Error('The database engine could not load. Refresh the page to retry.');
    return globalThis.initSqlJs(options);
  },
  wasmUrl: new URL('../vendor/sql-wasm.wasm', import.meta.url).href,
  fetchDatabase: async () => {
    const response = await fetch(versionedUrl('../data/railway.sqlite'), {cache:'no-store'});
    if (!response.ok) throw new Error('The train database could not load. Please try again.');
    return response.arrayBuffer();
  },
});

let configured;
globalThis.railwayDataSource = async (path,signal) => {
  if (!configured) configured = (async () => {
    const response = await fetch(versionedUrl('../config.json'),{cache:'no-store'});
    if (!response.ok) throw new Error('Website configuration could not be loaded. Please try again.');
    const config = await response.json();
    if (config.dataSource === 'api') return createApiDataSource(config.apiBaseUrl || '');
    if (config.dataSource === 'sqlite') return sqliteDataSource;
    throw new Error('Choose api or sqlite as the configured data source.');
  })().catch(error => { configured = undefined; throw error; });
  return (await configured)(path,signal);
};

await import(versionedUrl('../app.js').href);
