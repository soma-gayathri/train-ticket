const escapeHtml = value => String(value ?? '').replace(/[&<>"']/g,char=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[char]));
const bookingStoreKey='railway-demo-bookings-v1';
const bookingViewerKey='railway-demo-viewer-key';
const viewerKey=()=>{let key=localStorage.getItem(bookingViewerKey);if(!key){key=crypto.randomUUID();localStorage.setItem(bookingViewerKey,key);}return key;};
const initialTickets=number=>{let total=0;for(const character of String(number))total=(total*31)+character.charCodeAt(0);return 30+(Math.abs(total)%61);};
const bookedTickets=number=>{try{return JSON.parse(localStorage.getItem(bookingStoreKey)||'{}')[number]||0;}catch{return 0;}};
const availableTickets=number=>Math.max(0,initialTickets(number)-bookedTickets(number));
const saveBookedTickets=(number,count)=>{try{const bookings=JSON.parse(localStorage.getItem(bookingStoreKey)||'{}');bookings[number]=(bookings[number]||0)+count;localStorage.setItem(bookingStoreKey,JSON.stringify(bookings));}catch{}};
const availabilityText=number=>{const left=availableTickets(number);return left?`AVAILABLE · ${left} ticket${left===1?'':'s'} left`:'NOT AVAILABLE · FULL';};
const refreshAvailability=number=>document.querySelectorAll(`[data-ticket-availability="${CSS.escape(String(number))}"]`).forEach(item=>{const left=availableTickets(number);item.textContent=availabilityText(number);item.classList.toggle('ticket-full',left===0);const button=item.closest('.booking-action')?.querySelector('.book-ticket');if(button){button.disabled=left===0;button.textContent=left===0?'Full':'Book ticket';button.hidden=false;}});
const fareRules={"Sleeper (SL)":{base:40,perKm:.45,minimum:150,gst:0},"AC 3 Tier (3A)":{base:150,perKm:.95,minimum:500,gst:.05},"AC 2 Tier (2A)":{base:250,perKm:1.45,minimum:800,gst:.05},"Chair Car (CC)":{base:130,perKm:.62,minimum:250,gst:.05}};
const calculateDemoFare=(duration,distanceKm,travelClass,passengers)=>{const rule=fareRules[travelClass]||fareRules['Sleeper (SL)'];const routeDistance=Number(distanceKm);const durationHours=Math.max(1,Number(duration||600)/60);const fallbackKm=Math.round(durationHours*52);const estimatedKm=Math.min(3000,Math.max(120,Number.isFinite(routeDistance)&&routeDistance>0?Math.round(routeDistance):fallbackKm));const ticket=Math.max(rule.minimum,Math.round(rule.base+(estimatedKm*rule.perKm)));const reservation=20*passengers;const subtotal=ticket*passengers;const gst=Math.round(subtotal*rule.gst);return {estimatedKm,ticket,reservation,gst,total:subtotal+reservation+gst};};
const rupees=value=>new Intl.NumberFormat('en-IN',{style:'currency',currency:'INR',maximumFractionDigits:0}).format(value);
const seatAssignments=(trainNumber,travelClass,passengers)=>{const coachPrefix={'Sleeper (SL)':'S','AC 3 Tier (3A)':'B','AC 2 Tier (2A)':'A','Chair Car (CC)':'C'}[travelClass]||'S';const berthCycle=['Lower berth','Middle berth','Upper berth','Side lower','Side upper'];const seed=[...`${trainNumber}|${travelClass}`].reduce((total,char)=>(total*31+char.charCodeAt(0))>>>0,7);return passengers.map((passenger,index)=>{const berth=passenger.berthPreference==='No preference'?berthCycle[(seed+index)%berthCycle.length]:`${passenger.berthPreference} berth`;return {...passenger,bookingStatus:'Confirmed',coach:`${coachPrefix}${1+((seed+index)%8)}`,berthNumber:String(1+((seed+index*7)%72)),assignedBerth:berth};});};
const resetPassengerRows=form=>{const list=form.querySelector('.passenger-list');while(list.children.length>1)list.lastElementChild.remove();list.firstElementChild?.querySelectorAll('input,select').forEach(field=>field.value='');const addButton=form.querySelector('.add-passenger');if(addButton){addButton.disabled=false;addButton.textContent='+ Add passenger';}};
export function formatFare(paise,currency='INR') {
  if (!Number.isSafeInteger(paise) || paise < 0) throw new Error('Invalid fare amount.');
  return new Intl.NumberFormat('en-IN',{style:'currency',currency}).format(paise/100);
}
export function renderBooking(train) {
  const number = escapeHtml(train.number);
  const travelDate = String(train.travelDate || new Date().toISOString().slice(0,10));
  const ticketKey = `${train.number}|${travelDate}`;
  const available = availableTickets(ticketKey);
  const label = escapeHtml(train.bookingLabel || 'Book ticket');
  return `<div class="booking-action"><button type="button" class="book-ticket" data-book-train="${number}" data-book-ticket-key="${escapeHtml(ticketKey)}" data-book-name="${escapeHtml(train.name)}" ${available===0?'disabled':''}>${available===0?'Full':label}</button><span class="ticket-availability ${available===0?'ticket-full':''}" data-ticket-availability="${escapeHtml(ticketKey)}">${availabilityText(ticketKey)}</span><p class="booking-status" role="status" aria-live="polite"></p>
      <form class="booking-form" data-book-train="${number}" data-book-ticket-key="${escapeHtml(ticketKey)}" data-book-date="${escapeHtml(travelDate)}" data-book-from="${escapeHtml(train.fromStation || '')}" data-book-to="${escapeHtml(train.toStation || '')}" data-book-name="${escapeHtml(train.name)}" data-book-duration="${Math.max(60,Number(train.duration||600))}" data-book-distance="${Math.max(0,Number(train.distanceKm||0))}" hidden>
        <p class="booking-form-title">Passenger details <small>Demo only — do not enter real ID or payment information.</small></p>
        <div class="passenger-list"><div class="passenger-row"><label>Passenger name<input name="passengerName" autocomplete="name" required maxlength="60" placeholder="Enter full name"></label><label>Age<input name="age" type="number" min="1" max="120" required placeholder="Age"></label><label>Gender<select name="gender" required><option value="">Select</option><option>Female</option><option>Male</option><option>Other</option></select></label><label>Berth preference<select name="berth"><option>No preference</option><option>Lower</option><option>Middle</option><option>Upper</option><option>Side lower</option><option>Side upper</option></select></label></div></div>
        <label>Travel class<select name="travelClass"><option>Sleeper (SL)</option><option>AC 3 Tier (3A)</option><option>AC 2 Tier (2A)</option><option>Chair Car (CC)</option></select></label>
        <div class="booking-form-actions"><button type="button" class="add-passenger">+ Add passenger</button><button type="button" class="cancel-booking">Cancel</button><button type="submit" name="bookingAction" value="price" class="calculate-price">Calculate price</button><button type="submit" name="bookingAction" value="book">Book ticket</button></div>
      </form><section class="payment-review" hidden aria-live="polite"><h3>Review booking and price</h3><p class="payment-summary"></p><p class="payment-disclaimer">Illustrative demo price only. This is not an IRCTC fare and no real payment will be collected.</p><div class="booking-form-actions"><button type="button" class="confirm-demo-payment">Yes, pay &amp; book</button><button type="button" class="cancel-demo-payment">No, go back</button></div></section><section class="booking-confirmation" hidden aria-live="polite"></section></div>`;
}
export function renderExtras(train) {
  const number = escapeHtml(train.number);
  return `<div class="train-features">
    ${renderBooking(train)}
    <details data-feature="details" data-number="${number}"><summary>Train details</summary><div class="feature-content" aria-live="polite"></div></details>
    <details data-feature="schedule" data-number="${number}"><summary>Full train schedule</summary><div class="feature-content" aria-live="polite"></div></details>
  </div>`;
}

export function installTrainFeatures(root,readApi) {
  // Search can retry while stations are loading. Install these delegated
  // handlers once, otherwise one Add passenger click creates several rows.
  if (root.dataset.trainFeaturesInstalled === 'true') return;
  root.dataset.trainFeaturesInstalled = 'true';
  root.addEventListener('click',event => {
    const button = event.target.closest('.book-ticket');
    if (!button) return;
    const status = button.parentElement.querySelector('.booking-status');
    const form = button.parentElement.querySelector('.booking-form');
    resetPassengerRows(form);
    button.parentElement.classList.add('booking-page-open');
    form.hidden = false;
    status.textContent = `Enter passenger details for ${button.dataset.bookName}.`;
    button.hidden = true;
    form.elements.passengerName.focus();
  });

  root.addEventListener('submit',event => {
    const form = event.target;
    if (!form.matches('.booking-form')) return;
    event.preventDefault();
    const passengers=[...form.querySelectorAll('.passenger-row')].map(row=>({name:row.querySelector('[name="passengerName"]').value.trim(),age:Number(row.querySelector('[name="age"]').value),gender:row.querySelector('[name="gender"]').value,berthPreference:row.querySelector('[name="berth"]').value}));
    if (passengers.some(passenger=>!passenger.name||!Number.isInteger(passenger.age)||passenger.age<1||passenger.age>120||!passenger.gender)) return;
    const action = form.closest('.booking-action');
    const available=availableTickets(form.dataset.bookTicketKey);
    if(passengers.length>available){action.querySelector('.booking-status').textContent=`Only ${available} ticket${available===1?'':'s'} are available for this demo train.`;return;}
    const quote=calculateDemoFare(form.dataset.bookDuration,form.dataset.bookDistance,form.elements.travelClass.value,passengers.length);
    if(event.submitter?.value==='price'){
      action.querySelector('.booking-status').textContent=`Demo price for ${passengers.length} passenger${passengers.length===1?'':'s'}: ${rupees(quote.total)}. This is illustrative only; no ticket has been booked.`;
      return;
    }
    form.hidden = true;
    form.dataset.pendingPassengers=String(passengers.length);form.dataset.pendingTotal=String(quote.total);form.dataset.pendingPassengerDetails=JSON.stringify(passengers);
    const review=action.querySelector('.payment-review');review.querySelector('.payment-summary').textContent=`${passengers.length} passenger${passengers.length===1?'':'s'} · ${form.elements.travelClass.value} · route distance ${quote.estimatedKm} km · ticket ${rupees(quote.ticket)} each + reservation ${rupees(quote.reservation)}${quote.gst?` + GST ${rupees(quote.gst)}`:''} · Total ${rupees(quote.total)}.`;review.hidden=false;
    action.querySelector('.booking-status').textContent='Review the illustrative price, then choose Yes to confirm the demo booking.';
  });

  root.addEventListener('click',async event => {
    const button=event.target.closest('.confirm-demo-payment');
    if(!button)return;
    const action=button.closest('.booking-action');const form=action.querySelector('.booking-form');const count=Number(form.dataset.pendingPassengers||0);const available=availableTickets(form.dataset.bookTicketKey);
    if(!Number.isInteger(count)||count<1||count>available){action.querySelector('.payment-review').hidden=true;form.hidden=false;action.querySelector('.booking-status').textContent=`Only ${available} ticket${available===1?'':'s'} are available now. Please review again.`;return;}
    const quotedTotal=Number(form.dataset.pendingTotal||0);const pnr=`D${String(Date.now()).slice(-7)}${Math.floor(Math.random()*10)}`;
    let passengers=[];try{passengers=JSON.parse(form.dataset.pendingPassengerDetails||'[]');}catch{}
    const assignedPassengers=seatAssignments(form.dataset.bookTrain,form.elements.travelClass.value,passengers);
    try { await readApi.post('/api/bookings',{trainNumber:form.dataset.bookTrain,trainName:form.dataset.bookName,fromStation:form.dataset.bookFrom,toStation:form.dataset.bookTo,travelDate:form.dataset.bookDate,travelClass:form.elements.travelClass.value,totalAmount:quotedTotal,pnr,passengers:assignedPassengers,viewerKey:viewerKey()}); }
    catch(error){action.querySelector('.booking-status').textContent=`Booking was not saved: ${error.message}`;return;}
    saveBookedTickets(form.dataset.bookTicketKey,count);refreshAvailability(form.dataset.bookTicketKey);const remaining=availableTickets(form.dataset.bookTicketKey);
    const passengerDetails=assignedPassengers.map(passenger=>`<li><strong>${escapeHtml(passenger.name)}</strong><span><b>${escapeHtml(passenger.bookingStatus)}</b> · Coach ${escapeHtml(passenger.coach)} · Berth ${escapeHtml(passenger.berthNumber)} (${escapeHtml(passenger.assignedBerth)})</span></li>`).join('');
    const travelDate=new Date(`${form.dataset.bookDate}T00:00:00`).toLocaleDateString('en-IN',{day:'numeric',month:'long',year:'numeric'});
    const confirmation=action.querySelector('.booking-confirmation');
    confirmation.innerHTML=`<div class="confirmation-heading"><span class="confirmation-mark">✓</span><div><p class="confirmation-label">DEMO BOOKING CONFIRMED</p><h2>Your booking details</h2><p>No real payment was taken and no real railway ticket was created.</p></div></div><div class="ticket-grid"><div><span>Demo PNR</span><strong>${escapeHtml(pnr)}</strong></div><div><span>Ticket status</span><strong class="confirmed-status">Confirmed</strong></div><div><span>Travel date</span><strong>${escapeHtml(travelDate)}</strong></div><div><span>Train</span><strong>${escapeHtml(form.dataset.bookTrain)} · ${escapeHtml(form.dataset.bookName)}</strong></div><div><span>Route</span><strong>${escapeHtml(form.dataset.bookFrom)} → ${escapeHtml(form.dataset.bookTo)}</strong></div><div><span>Class</span><strong>${escapeHtml(form.elements.travelClass.value)}</strong></div><div><span>Amount paid</span><strong>${rupees(quotedTotal)}</strong></div><div><span>Availability after booking</span><strong>${remaining?`${remaining} ticket${remaining===1?'':'s'} remaining`:'Train full'}</strong></div></div><section class="confirmed-passengers"><h3>Passenger details</h3><ul>${passengerDetails}</ul></section><div class="booking-form-actions"><button type="button" class="close-booking-confirmation">Done</button></div>`;
    action.querySelector('.payment-review').hidden=true;form.reset();resetPassengerRows(form);confirmation.hidden=false;delete form.dataset.pendingPassengers;delete form.dataset.pendingTotal;delete form.dataset.pendingPassengerDetails;action.querySelector('.booking-status').textContent=`Booking confirmed. Demo PNR: ${pnr}.`;
  });

  root.addEventListener('click',event => {
    const button=event.target.closest('.close-booking-confirmation');
    if(!button)return;
    const action=button.closest('.booking-action');action.querySelector('.booking-confirmation').hidden=true;action.classList.remove('booking-page-open');action.querySelector('.book-ticket').hidden=false;
  });

  root.addEventListener('click',event => {
    const button=event.target.closest('.cancel-demo-payment');
    if(!button)return;
    const action=button.closest('.booking-action');action.querySelector('.payment-review').hidden=true;action.querySelector('.booking-form').hidden=false;action.querySelector('.booking-status').textContent='Payment cancelled. Update passenger details or price and review again.';
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
    resetPassengerRows(form);
    const action=form.closest('.booking-action');
    action.classList.remove('booking-page-open');
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
