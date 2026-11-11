import { createApiDataSource } from './api-client.js?v=c4aa9971fb2f';

const release = new URL(import.meta.url).searchParams.get('v');
globalThis.railwayAssetVersion = release;
const configUrl = new URL('./config.json', import.meta.url);
const config = await fetch(configUrl, { cache: 'no-store' }).then(response => response.ok ? response.json() : {});
// GitHub Pages uses the configured ngrok URL; the local site keeps its own origin.
globalThis.railwayDataSource = createApiDataSource(config.apiBaseUrl || '');
const app = new URL('./app.js', import.meta.url);
if (release) app.searchParams.set('v', release);
await import(app.href);
