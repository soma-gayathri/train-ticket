// The public API base URL is configuration, never a place for credentials.
export function createApiDataSource(baseUrl='', fetchImpl=globalThis.fetch) {
  const base = baseUrl.trim().replace(/\/+$/,'');
  if (base) {
    const parsed = new URL(base);
    if (!['http:','https:'].includes(parsed.protocol) || parsed.username || parsed.password || parsed.search || parsed.hash) throw new Error('Use a plain HTTP(S) backend URL without credentials, query parameters, or a fragment.');
    if (globalThis.location?.protocol === 'https:' && parsed.protocol !== 'https:') throw new Error('This HTTPS website requires an HTTPS backend URL.');
  }
  return async (path,signal) => {
    if (!path.startsWith('/api/')) throw new Error('Only railway API paths are supported.');
    const controller = new AbortController();
    const abort = () => controller.abort();
    if (signal?.aborted) abort(); else signal?.addEventListener('abort',abort,{once:true});
    const timer = setTimeout(abort,15000);
    try {
      const response = await fetchImpl(base+path,{signal:controller.signal,cache:'no-store',headers:{Accept:'application/json'}});
      let data;
      try { data = await response.json(); } catch { throw new Error('The backend did not return valid JSON. Check the API base URL.'); }
      if (!response.ok) throw new Error(data.error || data.detail || `Backend request failed (${response.status}).`);
      return data;
    } catch(error) {
      if (signal?.aborted) throw new DOMException('Search cancelled','AbortError');
      if (controller.signal.aborted) throw new Error('The backend request timed out. Please try again.');
      if (error instanceof TypeError) throw new Error('Could not reach the backend. Check that it is running and its URL and allowed frontend origin are configured.');
      throw error;
    } finally { clearTimeout(timer); signal?.removeEventListener('abort',abort); }
  };
}
