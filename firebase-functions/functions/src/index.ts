/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// import {onRequest} from "firebase-functions/v2/https";
// import * as logger from "firebase-functions/logger";

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

import { onCall } from "firebase-functions/v2/https";
import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

admin.initializeApp();

exports.sendNotification = onCall(async(data: any, context: any) => {
    const fcmToken = data.data.fcmToken
    const requestByProfileName = data.data.requestByProfileName
    const requestByProfileRoomCode = data.data.requestByProfileRoomCode

    const message: any = {
    notification: {
      title: 'Hello from Firebase!',
      body: 'This is a test notification.',
    },
    token: fcmToken,
    data : {
      'requestByProfileName': requestByProfileName,
      'requestByProfileRoomCode': requestByProfileRoomCode
    }
  };

  try {
    const response = await admin.messaging().send(message);
    console.log('Successfully sent message:', response);
    return { success: true, messageId: response };
  } catch (error) {
    console.error('Error sending message:', error);
    throw new functions.https.HttpsError('internal', 'Failed to send notification', error);
  }
});
