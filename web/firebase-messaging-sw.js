// Import Firebase scripts
importScripts('https://www.gstatic.com/firebasejs/10.12.2/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.12.2/firebase-messaging-compat.js');

// Initialize Firebase
firebase.initializeApp({
  apiKey: 'AIzaSyAAHC7I76L4y8g4H7LODYmDd0SI2SqILTw',
  appId: '1:408149573750:web:34d8681be80f9e96131f57',
  messagingSenderId: '408149573750',
  projectId: 'opulent-prime-app',
  authDomain: 'opulent-prime-app.firebaseapp.com',
  storageBucket: 'opulent-prime-app.firebasestorage.app',
});

// Retrieve an instance of Firebase Messaging so that it can handle background messages
const messaging = firebase.messaging();

// Optional: Handle background messages
messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  
  const notificationTitle = payload.notification?.title || 'New Notification';
  const notificationOptions = {
    body: payload.notification?.body || '',
    icon: '/icons/Icon-192.png',
    badge: '/icons/Icon-192.png',
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});

