const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.requestAdFunction = functions.firestore
    .document("userRequestedAds/{docId}")
    .onCreate((snap, context) => {
      return admin.messaging().sendToTopic(snap.data().adId, {
        notification: {
          title: "User Request",
          body: "Someone has placed a request for your ad!",
          clickAction: "FLUTTER_NOTIFICATION_CLICK"}});
    });
exports.joinConfirmation = functions.firestore
    .document("userJoinedAds/{docId}")
    .onCreate((snap, context) => {
      return admin.messaging().sendToTopic(snap.id, {
        notification: {
          title: "Congrats",
          body: "Your ad request has been accepted",
          clickAction: "FLUTTER_NOTIFICATION_CLICK"}});
    });

exports.finishTripNotifications = functions.firestore
    .document("FinishedTrips/{docId}")
    .onCreate((snap, context) => {
      const fare = snap.data().fare;
      const l = snap.data().passengers;
      // eslint-disable-next-line max-len
      const topicsConditions = `'${l[0]}' in topics || '${l[1]}' in topics || '${l[2]}' in topics`;
      return admin.messaging().sendToCondition(topicsConditions, {
        notification: {
          title: "Trip ended!",
          body: "Your trip has anded with fare : - "+ fare,
          clickAction: "FLUTTER_NOTIFICATION_CLICK"}}
      );
    });

