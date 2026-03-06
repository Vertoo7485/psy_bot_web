self.addEventListener('install', event => {
  console.log('Service Worker installed')
  self.skipWaiting()
})

self.addEventListener('activate', event => {
  console.log('Service Worker activated')
  event.waitUntil(clients.claim())
})

self.addEventListener('push', function(event) {
  const options = {
    body: event.data.text(),
    icon: '/assets/icon-192x192.png',
    badge: '/assets/icon-192x192.png',
    vibrate: [200, 100, 200],
    data: {
      dateOfArrival: Date.now(),
      primaryKey: 1
    },
    actions: [
      {action: 'open', title: 'Открыть'},
      {action: 'close', title: 'Закрыть'}
    ]
  }

  event.waitUntil(
    self.registration.showNotification('PsyBot', options)
  )
})

self.addEventListener('notificationclick', function(event) {
  event.notification.close()
  
  if (event.action === 'open') {
    event.waitUntil(
      clients.openWindow('/')
    )
  }
})