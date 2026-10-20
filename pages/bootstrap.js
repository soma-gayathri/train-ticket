import { createDataSource } from './database.js';

const release = new URL(import.meta.url).searchParams.get('v');
globalThis.railwayAssetVersion = release;
function versionedUrl(path) {
  const url = new URL(path, import.meta.url);
  if (release) url.searchParams.set('v',release);
  return url;
}

globalThis.railwayDataSource = createDataSource({
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

await import(versionedUrl('../app.js').href);
