var admin = require("firebase-admin");

// ownerId - who owns the picture someone liked
// userId - id of the user who liked the picture
// picture - metadata about the picture

async function onUserPictureLiked(ownerId, userId, text) {
  // Get the owners details
  const owner = admin.firestore().collection("users").doc(ownerId).get();

  // Get the users details
  const user = admin.firestore().collection("users").doc(userId).get();

  await admin.messaging().sendToDevice(
    owner.tokens, // ['token_1', 'token_2', ...]
    {
      data: {
        owner: JSON.stringify(owner),
        user: JSON.stringify(user),
        picture: JSON.stringify(text),
      },
    },
    {
      // Required for background/quit data-only messages on iOS
      contentAvailable: true,
      // Required for background/quit data-only messages on Android
      priority: "high",
    }
  );
}

