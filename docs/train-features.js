const escapeHtml = value => String(value ?? '').replace(/[&<>"']/g,char=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[char]));
export function formatFare(paise,currency='INR') {
  if (!Number.isSafeInteger(paise) || paise < 0) throw new Error('Invalid fare amount.');
  return new Intl.NumberFormat('en-IN',{style:'currency',currency}).format(paise/100);
}
export function renderExtras(train) {
  const number = escapeHtml(train.number);
  return `<div class="train-features">
    <div class="booking-action"><button type="button" class="book-ticket" data-book-train="${number}" data-book-name="${escapeHtml(train.name)}">Book ticket</button><p class="booking-status" role="status" aria-live="polite"></p></div>
    <details data-feature="details" data-number="${number}"><summary>Train details</summary><div class="feature-content" aria-live="polite"></div></details>
    <details data-feature="schedule" data-number="${number}"><summary>Full train schedule</summary><div class="feature-content" aria-live="polite"></div></details>
  </div>`;
}

export function installTrainFeatures(root,readApi) {
  root.addEventListener('click',event => {
    const button = event.target.closest('.book-ticket');
    if (!button) return;
    const status = button.parentElement.querySelector('.booking-status');
    status.textContent = `${button.dataset.bookName} selected. This is a demo booking; payment and real ticket confirmation are not available yet.`;
    button.textContent = 'Selected for booking';
    button.disabled = true;
  });

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

}
