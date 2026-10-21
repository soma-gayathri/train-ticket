import { createApiDataSource } from './api-client.js?v=c7f3aaefe8a2';

const release = new URL(import.meta.url).searchParams.get('v');
globalThis.railwayAssetVersion = release;
// Frontend and API share the Spring Boot server and origin.
globalThis.railwayDataSource = createApiDataSource();
const app = new URL('./app.js', import.meta.url);
if (release) app.searchParams.set('v', release);
await import(app.href);
