// Old domain: remove the cached Flutter app so the browser follows the 301 to the new domain.
self.addEventListener('install', () => self.skipWaiting());
self.addEventListener('activate', (event) => event.waitUntil((async () => {
  await self.registration.unregister();
  for (const key of await caches.keys()) await caches.delete(key);
  for (const client of await self.clients.matchAll({ type: 'window' })) client.navigate(client.url);
})()));
