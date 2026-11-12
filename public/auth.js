import { createApiDataSource } from './api-client.js';

const authKey = 'railway-demo-auth-user';
const $ = id => document.getElementById(id);
const config = await fetch('./config.json', { cache: 'no-store' }).then(response => response.ok ? response.json() : {});
const api = createApiDataSource(config.apiBaseUrl || '');
let mode = 'login';
const nextPage = new URLSearchParams(location.search).get('next') || './';

function setMode(nextMode) {
  mode = nextMode;
  const register = mode === 'register';
  $('name-field').hidden = !register;
  $('auth-name').required = register;
  $('auth-password').autocomplete = register ? 'new-password' : 'current-password';
  $('auth-submit').textContent = register ? 'Create account' : 'Sign in';
  document.querySelectorAll('[data-auth-mode]').forEach(button => {
    const active = button.dataset.authMode === mode;
    button.classList.toggle('active', active);
    button.setAttribute('aria-selected', String(active));
  });
  $('auth-error').hidden = true;
}

document.querySelectorAll('[data-auth-mode]').forEach(button => button.addEventListener('click', () => setMode(button.dataset.authMode)));
$('auth-form').addEventListener('submit', async event => {
  event.preventDefault();
  const name = $('auth-name').value.trim();
  const email = $('auth-email').value.trim();
  const password = $('auth-password').value;
  const error = $('auth-error');
  if (mode === 'register' && name.length < 2) { error.textContent = 'Enter your name.'; error.hidden = false; return; }
  $('auth-submit').disabled = true;
  $('auth-submit').textContent = mode === 'register' ? 'Creating account…' : 'Signing in…';
  try {
    const response = await api.post(mode === 'register' ? '/api/auth/register' : '/api/auth/login', mode === 'register' ? { name, email, password } : { email, password });
    localStorage.setItem(authKey, JSON.stringify({ name: response.user.name, email: response.user.email }));
    location.assign(nextPage);
  } catch (requestError) {
    error.textContent = requestError.message || 'Could not sign in. Please try again.';
    error.hidden = false;
  } finally {
    $('auth-submit').disabled = false;
    $('auth-submit').textContent = mode === 'register' ? 'Create account' : 'Sign in';
  }
});
