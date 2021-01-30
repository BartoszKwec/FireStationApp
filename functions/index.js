const functions = require('firebase-functions');
const admin= requrie('firebase-admin');
admin.initializeApp();
const database= admin.firestore();

// exports.sendPush = functions.firestore.document('emergencies/{emergencieId}').onWrite((change, context) => {
//     const sender_name = change.after.data().sender_name;
//     // const docid = context.params;
//     const title = change.after.data().title;
//     const description = change.after.data().description;
//     const token = change.after.data().token;

//     console.log('sender_name' + sender_name);

//     console.log('title: ' + title);
//     console.log('description:' + description);
//     console.log('token: ' + token);
//     let alertLoad = {
//         notifications:{
//             title: 'ALARM',
//             body: ` ${title} : ${description}`
//         },
//         data: {
//             title: title,
//         name: sender_name,
//         description: description,
//         }
        
//     },
//     return admin.messaging().sendToDevice(token, alertLoad);
// });

exports.checkForEventTransition = functions.pubsub.schedule('0 * * * *').onRun(
    async (_context) => {
    const query = await database.collection("groups")
        .where("currentEventDue", '<=', admin.firestore.Timestamp.now())
        .get();
    query.forEach(async eachGroup => {
        var currentIndex = eachGroup.data()["indexPickingEvent"];
        var totalMembers = eachGroup.data()["members"].length;
        var nextIndex;

        if (currentIndex >= (totalMembers - 1)) {
            nextIndex = 0;
        } else {
            nextIndex = currentIndex + 1;
        }

        if ((eachGroup.data()["nextEventId"] !== null) || (eachGroup.data()["nextEventId"] !== "waiting")) {
            await database.doc('groups/' + eachGroup.id).update({
                "currentEventDue": eachGroup.data()["nextEventDue"],
                "currentEventId": eachGroup.data()["nextEventId"],
                "nextEventId": "waiting",
                "indexPickingEvent": nextIndex,
            })
        } else {
            await database.doc('groups/' + eachGroup.id).update({
                "currentEventDue": "waiting",
                "currentEventId": "waiting",
                "nextEventId": "waiting",
                "indexPickingEvent": nextIndex,
            })
        }
    })
})


exports.onCreateNotification = functions.firestore.document("/emergencies/{emergencieDoc}").onCreate(
async (notifSnapshot, _context) => { 
        
        
    var tokens = notifSnapshot.data()['tokens'];
    var description = notifSnapshot.data()['description'];
    var author = notifSnapshot.data()['author'];

    var title = `ALARM!`;
    var body = ` ${description} by ${author}`;

    tokens.forEach(async eachToken => {
        const message = {
            notification: { title: title, body: body },
            token: eachToken,
            data: { click_action: 'FLUTTER_NOTIFICATION_CLICK' },
        }

        admin.messaging().send(message).then(response => {
            return console.log("Notification Succesful");
        }).catch(error => {
            return console.log("Error: " + error);
        });
    });



});
// exports.notifyUsers = functions.database.ref('/messages/{messageId}').onCreate(async (snapshot, context) => {
//     const name = context.params.messageId;
//     const message = snapshot.val().toString();
//     const tokens = await getTokens();
//     const payload = {
//         notification: {
//             title: New message from ${name},
//             body: message,
//         },
//         tokens: tokens,
//     };
//     await admin.messaging().sendMulticast(payload);
// })