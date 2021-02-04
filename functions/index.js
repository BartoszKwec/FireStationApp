const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const database = admin.firestore();

exports.sendNotification = functions.pubsub.schedule('* * * * *').onRun(async (context) => {

  const query = await database.collection("emergencies").where("sent", "==", false).get();
  

  query.forEach(async snapshot => {
      
      sendNotification(snapshot);
      await database.collection('emergencies').doc(snapshot.id).update({
          "sent": true,
          
      });
  });

  function sendNotification(snapshot) {
      var tokens = snapshot.data()['tokens'];
      let title = "Alarm!";
      let body = "Twój zespół Cię potrzebuje!";
    tokens.forEach(async eachToken =>{
        const message = {
          notification: { title: title, body: body },
          token: eachToken,
          data: { click_action: 'FLUTTER_NOTIFICATION_CLICK' },
      }
            admin.messaging().send(message).then((response) => {
            return console.log('Successfully sent message:', response);
        }).catch((error) => {
            return console.log('Error sending message:', error);
        });
    })
      

    
}
  return console.log('Koniec funkcji');
});


