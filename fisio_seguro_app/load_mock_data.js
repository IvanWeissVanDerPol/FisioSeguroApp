const admin = require('firebase-admin');

// Initialize Firebase Admin with a service account
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://your-database-url.firebaseio.com'
});

const db = admin.firestore();

// Assume mockData is an array of objects
const mockData = [
  { name: 'John Doe', age: 25, email: 'john.doe@example.com' },
  // ...other mock data
];

// Upload mock data to Firestore
const promises = mockData.map((data, index) => {
  return db.collection('users').doc(String(index)).set(data);
});

Promise.all(promises)
  .then(() => console.log('Data uploaded successfully'))
  .catch(error => console.error('Error uploading data: ', error));
