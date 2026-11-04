const escapeHtml = value => String(value ?? '').replace(/[&<>"']/g,char=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[char]));
const bookingStoreKey='railway-demo-bookings-v1';
const initialTickets=number=>{let total=0;for(const character of String(number))total=(total*31)+character.charCodeAt(0);return 30+(Math.abs(total)%61);};
const bookedTickets=number=>{try{return JSON.parse(localStorage.getItem(bookingStoreKey)||'{}')[number]||0;}catch{return 0;}};
const availableTickets=number=>Math.max(0,initialTickets(number)-bookedTickets(number));
const saveBookedTickets=(number,count)=>{try{const bookings=JSON.parse(localStorage.getItem(bookingStoreKey)||'{}');bookings[number]=(bookings[number]||0)+count;localStorage.setItem(bookingStoreKey,JSON.stringify(bookings));}catch{}};
const availabilityText=number=>{const left=availableTickets(number);return left?`AVAILABLE · ${left} ticket${left===1?'':'s'} left`:'NOT AVAILABLE · FULL';};
const refreshAvailability=number=>document.querySelectorAll(`[data-ticket-availability="${CSS.escape(String(number))}"]`).forEach(item=>{const left=availableTickets(number);item.textContent=availabilityText(number);item.classList.toggle('ticket-full',left===0);const button=item.closest('.booking-action')?.querySelector('.book-ticket');if(button){button.disabled=left===0;button.textContent=left===0?'Full':'Book ticket';button.hidden=false;}});
export function formatFare(paise,currency='INR') {
  if (!Number.isSafeInteger(paise) || paise < 0) throw new Error('Invalid fare amount.');
  return new Intl.NumberFormat('en-IN',{style:'currency',currency}).format(paise/100);
}
export function renderExtras(train) {
  const number = escapeHtml(train.number);
  const available = availableTickets(train.number);
  return `<div class="train-features">
    <div class="booking-action"><button type="button" class="book-ticket" data-book-train="${number}" data-book-name="${escapeHtml(train.name)}" ${available===0?'disabled':''}>${available===0?'Full':'Book ticket'}</button><span class="ticket-availability ${available===0?'ticket-full':''}" data-ticket-availability="${number}">${availabilityText(train.number)}</span><p class="booking-status" role="status" aria-live="polite"></p>
      <form class="booking-form" data-book-train="${number}" data-book-name="${escapeHtml(train.name)}" hidden>
        <p class="booking-form-title">Passenger details <small>Demo only — do not enter real ID or payment information.</small></p>
        <div class="passenger-list"><div class="passenger-row"><label>Passenger name<input name="passengerName" autocomplete="name" required maxlength="60" placeholder="Enter full name"></label><label>Age<input name="age" type="number" min="1" max="120" required placeholder="Age"></label><label>Gender<select name="gender" required><option value="">Select</option><option>Female</option><option>Male</option><option>Other</option></select></label><label>Berth preference<select name="berth"><option>No preference</option><option>Lower</option><option>Middle</option><option>Upper</option><option>Side lower</option><option>Side upper</option></select></label></div></div>
        <label>Travel class<select name="travelClass"><option>Sleeper (SL)</option><option>AC 3 Tier (3A)</option><option>AC 2 Tier (2A)</option><option>Chair Car (CC)</option></select></label>
        <div class="booking-form-actions"><button type="button" class="add-passenger">+ Add passenger</button><button type="button" class="cancel-booking">Cancel</button><button type="submit">Confirm demo booking</button></div>
      </form></div>
    <details data-feature="details" data-number="${number}"><summary>Train details</summary><div class="feature-content" aria-live="polite"></div></details>
    <details data-feature="schedule" data-number="${number}"><summary>Full train schedule</summary><div class="feature-content" aria-live="polite"></div></details>
  </div>`;
}

export function installTrainFeatures(root,readApi) {
  root.addEventListener('click',event => {
    const button = event.target.closest('.book-ticket');
    if (!button) return;
    const status = button.parentElement.querySelector('.booking-status');
    const form = button.parentElement.querySelector('.booking-form');
    form.hidden = false;
    status.textContent = `Enter passenger details for ${button.dataset.bookName}.`;
    button.hidden = true;
    form.elements.passengerName.focus();
  });

  root.addEventListener('submit',event => {
    const form = event.target;
    if (!form.matches('.booking-form')) return;
    event.preventDefault();
    const passengers=[...form.querySelectorAll('.passenger-row')].map(row=>({name:row.querySelector('[name="passengerName"]').value.trim(),age:Number(row.querySelector('[name="age"]').value),gender:row.querySelector('[name="gender"]').value}));
    if (passengers.some(passenger=>!passenger.name||!Number.isInteger(passenger.age)||passenger.age<1||passenger.age>120||!passenger.gender)) return;
    const pnr = `D${String(Date.now()).slice(-7)}${Math.floor(Math.random()*10)}`;
    const action = form.closest('.booking-action');
    const available=availableTickets(form.dataset.bookTrain);
    if(passengers.length>available){action.querySelector('.booking-status').textContent=`Only ${available} ticket${available===1?'':'s'} are available for this demo train.`;return;}
    saveBookedTickets(form.dataset.bookTrain,passengers.length);
    refreshAvailability(form.dataset.bookTrain);
    const remaining=availableTickets(form.dataset.bookTrain);
    action.querySelector('.booking-status').textContent = `Demo booking confirmed for ${passengers.length} passenger${passengers.length===1?'':'s'}. Demo PNR: ${pnr}. ${remaining?`${remaining} ticket${remaining===1?'':'s'} remaining.`:'This train is now full.'} No payment was taken and no real ticket was created.`;
    form.hidden = true;
    form.reset();
    action.querySelector('.book-ticket').hidden = false;
  });

  root.addEventListener('click',event => {
    const button=event.target.closest('.add-passenger');
    if(!button)return;
    const form=button.closest('.booking-form');
    const list=form.querySelector('.passenger-list');
    if(list.children.length>=6)return;
    const row=list.firstElementChild.cloneNode(true);
    row.querySelectorAll('input,select').forEach(field=>field.value='');
    list.append(row);
    if(list.children.length===6){button.disabled=true;button.textContent='Maximum 6 passengers';}
  });

  root.addEventListener('click',event => {
    const button=event.target.closest('.cancel-booking');
    if(!button)return;
    const form=button.closest('.booking-form');
    form.hidden=true;
    form.reset();
    const action=form.closest('.booking-action');
    action.querySelector('.book-ticket').hidden=false;
    action.querySelector('.booking-status').textContent='';
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
