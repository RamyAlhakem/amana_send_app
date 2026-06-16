// Firebase Cloud Messaging service worker for web background notifications.
// This file must be served from the root of the web app (e.g. /firebase-messaging-sw.js).

importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyBPks5U1NjF7qC8gxz09DF-aFVgA3DRAI8',
  authDomain: 'amana-send.firebaseapp.com',
  projectId: 'amana-send',
  storageBucket: 'amana-send.appspot.com',
  messagingSenderId: '456472455625',
  appId: '1:456472455625:web:7d57cb5f2991ab609a2018',
});

const messaging = firebase.messaging();

// Handle background messages. When the web app is not in the foreground,
// Firebase uses this handler to display notifications via the browser's
// built-in Notification API.
messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Received background message', payload);

  const notificationTitle = payload.notification?.title ?? payload.data?.title ?? '';
  const notificationOptions = {
    body: payload.notification?.body ?? payload.data?.body ?? '',
    icon: '/icons/Icon-192.png',
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
