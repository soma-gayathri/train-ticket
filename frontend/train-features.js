const escapeHtml = value => String(value ?? '').replace(/[&<>"']/g,char=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[char]));
export function formatFare(paise,currency='INR') {
  if (!Number.isSafeInteger(paise) || paise < 0) throw new Error('Invalid fare amount.');
  return new Intl.NumberFormat('en-IN',{style:'currency',currency}).format(paise/100);
}
export function renderExtras(train) {
  const number = escapeHtml(train.number);
  return `<div class="train-features">
    <details data-feature="details" data-number="${number}"><summary>Train details</summary><div class="feature-content" aria-live="polite"></div></details>
    <details data-feature="schedule" data-number="${number}"><summary>Full train schedule</summary><div class="feature-content" aria-live="polite"></div></details>
    <details><summary>Calculate sample fare</summary><div class="feature-content"><p class="sample-fare-note">Illustrative pricing only. This does not check real fares or class availability.</p>
      <form class="fare-form" data-number="${number}" data-from="${escapeHtml(train.departure.code)}" data-to="${escapeHtml(train.arrival.code)}">
        <label>Travel class<select name="travelClass"><option value="SL">Sleeper (SL)</option><option value="3A">AC 3 Tier (3A)</option><option value="2A">AC 2 Tier (2A)</option><option value="CC">Chair Car (CC)</option></select></label>
        <label>Passengers<input name="passengers" type="number" min="1" max="6" step="1" value="1" required></label>
        <button type="submit">Calculate fare</button>
      </form><p class="fare-output" role="status" aria-live="polite"></p></div></details>
  </div>`;
}

export function installTrainFeatures(root,readApi) {
  root.addEventListener('toggle',async event => {
    const panel = event.target;
    if (!panel.matches('details[data-feature]') || !panel.open || panel.dataset.loaded || panel.dataset.loading) return;
    const content = panel.querySelector('.feature-content');
    content.textContent = 'Loading sample train information…'; panel.dataset.loading = 'true';
    try {
      const path = `/api/trains/${encodeURIComponent(panel.dataset.number)}${panel.dataset.feature === 'schedule' ? '/schedule' : ''}`;
      const data = await readApi(path);
      if (!panel.isConnected) return;
      if (panel.dataset.feature === 'details') {
        content.innerHTML = `<p><strong>${escapeHtml(data.name)}</strong> · ${escapeHtml(data.number)} · ${escapeHtml(data.type)}</p>
          <p>${escapeHtml(data.stops[0].name)} → ${escapeHtml(data.stops.at(-1).name)} · ${data.stops.length} stations</p><p class="sample-fare-note">Sample train information; not a verified live service.</p>`;
      } else {
        content.innerHTML = '<div class="stop-heading"><span>FULL ROUTE · SAMPLE</span><span>ARRIVAL</span><span>DEPARTURE</span></div>' + data.stops.map(stop=>{
          const time = kind => stop[kind] ? `${escapeHtml(stop[kind])}${stop[`${kind}Day`] > 0 ? ` <span class="day-label">+${stop[`${kind}Day`]} day</span>` : ''}` : '—';
          return `<div class="stop-row"><div class="stop-name">${escapeHtml(stop.name)}<small>${escapeHtml(stop.code)}</small></div><div>${time('arrival')}</div><div>${time('departure')}</div></div>`;
        }).join('');
      }
      panel.dataset.loaded = 'true';
    } catch(error) { if (panel.isConnected) content.textContent = `${error.message} Close and reopen to retry.`; }
    finally { delete panel.dataset.loading; }
  },true);

  root.addEventListener('submit',async event => {
    const form = event.target;
    if (!form.matches('.fare-form')) return;
    event.preventDefault();
    const output = form.parentElement.querySelector('.fare-output');
    const button = form.querySelector('button');
    const passengers = Number(form.elements.passengers.value);
    if (!Number.isInteger(passengers) || passengers < 1 || passengers > 6) { output.textContent = 'Passengers must be between 1 and 6.'; return; }
    const params = new URLSearchParams({from:form.dataset.from,to:form.dataset.to,travelClass:form.elements.travelClass.value,passengers:String(passengers)});
    button.disabled = true; output.textContent = 'Calculating sample fare…';
    try {
      const data = await readApi(`/api/trains/${encodeURIComponent(form.dataset.number)}/fare?${params}`);
      if (form.isConnected) output.textContent = `${formatFare(data.totalFarePaise,data.currency)} total for ${data.passengers} passenger${data.passengers === 1 ? '' : 's'} (${formatFare(data.unitFarePaise,data.currency)} each). ${data.disclaimer}`;
    } catch(error) { if (form.isConnected) output.textContent = error.message; }
    finally { button.disabled = false; }
  });
}
