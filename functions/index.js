const functions = require("firebase-functions");

// // Create and deploy your first functions
// // https://firebase.google.com/docs/functions/get-started
//
exports.saveFCMToken = functions.https.onRequest((request, response) => {
  response.set('Access-Control-Allow-Origin'.'*')
  response.set('Access-Control-Allow-Origin'.'GET,POST')
  const fcmToken = request.query.fcm;
  const db = getFirestore();
  const tokenRef = db.collection('fcm').doc('token');
  const token1 = await tokenRef.get();
  const token = token1.data();
  if (token["tokenList"].indexOf(fcmToken)<0) {
    token["tokenList"].push(fcmToken);
  }
});
