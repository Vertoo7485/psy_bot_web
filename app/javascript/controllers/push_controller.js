import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
  console.log('🔥 Push controller connected')
  if ('serviceWorker' in navigator && 'PushManager' in window) {
    this.registerServiceWorker()
  } else {
    console.log('❌ Push не поддерживается браузером')
  }
}

  async registerServiceWorker() {
    try {
      const registration = await navigator.serviceWorker.register('/service-worker.js')
      console.log('Service Worker registered')
      
      const subscription = await registration.pushManager.getSubscription()
      if (!subscription) {
        this.requestPermission(registration)
      }
    } catch (error) {
      console.error('Service Worker registration failed:', error)
    }
  }

  async requestPermission(registration) {
  try {
    console.log('Запрашиваем разрешение...')
    console.log('VAPID ключ:', this.data.get('vapidPublicKey'))
    
    const subscription = await registration.pushManager.subscribe({
      userVisibleOnly: true,
      applicationServerKey: this.urlBase64ToUint8Array(this.data.get('vapidPublicKey'))
    })
    
    console.log('✅ Подписка получена:', subscription)
    console.log('Endpoint:', subscription.endpoint)
    
    const p256dh = subscription.getKey('p256dh')
    const auth = subscription.getKey('auth')
    
    console.log('p256dh (raw):', p256dh)
    console.log('auth (raw):', auth)
    
    const p256dhBase64 = this.arrayBufferToBase64(p256dh)
    const authBase64 = this.arrayBufferToBase64(auth)
    
    console.log('p256dh (base64):', p256dhBase64)
    console.log('auth (base64):', authBase64)
    
    // Отправляем подписку на сервер
    const response = await fetch('/push_subscriptions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({
        push_subscription: {
          endpoint: subscription.endpoint,
          p256dh: p256dhBase64,
          auth: authBase64
        }
      })
    })
    
    const data = await response.json()
    console.log('✅ Ответ сервера:', data)
    
  } catch (error) {
    console.error('❌ Ошибка:', error)
  }
}

  urlBase64ToUint8Array(base64String) {
    const padding = '='.repeat((4 - base64String.length % 4) % 4)
    const base64 = (base64String + padding).replace(/\-/g, '+').replace(/_/g, '/')
    const rawData = window.atob(base64)
    const outputArray = new Uint8Array(rawData.length)
    
    for (let i = 0; i < rawData.length; ++i) {
      outputArray[i] = rawData.charCodeAt(i)
    }
    return outputArray
  }

  arrayBufferToBase64(buffer) {
  const bytes = new Uint8Array(buffer);
  const len = bytes.byteLength;
  let binary = '';
  for (let i = 0; i < len; i++) {
    binary += String.fromCharCode(bytes[i]);
  }
  return btoa(binary);
}
}