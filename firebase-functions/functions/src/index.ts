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

// export const sendNotification = async (token: string, title: string, body: string, data?: Record<string, string>) => {
//     const message = {
//     notification: {
//         title: title,
//         body: body,
//     },
//     data: data,
//     token: token,
//     };

//     try {
//     const response = await admin.messaging().send(message);
//     console.log('Successfully sent message:', response);
//     return response;
//     } catch (error: any) {
//     console.error('Error sending message:', error);
//     throw error;
//     }
// };

exports.sendNotification = onCall(async(data: any, context: any) => {
    const fcmToken = data.data.fcmToken

    const message: any = {
    notification: {
      title: 'Hello from Firebase!',
      body: 'This is a test notification.',
    },
    token: fcmToken,
  };

  try {
    const response = await admin.messaging().send(message);
    console.log('Successfully sent message:', response);
    return { success: true, messageId: response };
  } catch (error) {
    console.error('Error sending message:', error);
    throw new functions.https.HttpsError('internal', 'Failed to send notification', error);
  }


   // return { message: ` this is the fcm token ${fcmToken}`, data: "testtet" };
});

// exports.myFunctionName = async (data: any, response: any) => {
//     const fcmToken = data.data.fcmToken

//     const deviceToken = fcmToken; // Replace with the actual device token
//     const notificationTitle = 'Hello from Firebase!';
//     const notificationBody = 'This is a test notification.';
//     const notificationData = { customKey: 'customValue' };

//     try {
//     await sendNotification(deviceToken, notificationTitle, notificationBody, notificationData);
//     response.status(200).send('Notification sent successfully!');
//     } catch (error: any) {
//     response.status(500).send(`Error sending notification: ${error.message}`);
//     }
// };




// export const sendNotification = functions.https.onCall(async (data: any, context: any) => {
//   const message = {
//     notification: {
//       title: 'Hello from Firebase!',
//       body: 'This is a test notification.',
//     },
//     token: data.data.token,
//   };

//   try {
//     const response = await admin.messaging().send(message);
//     console.log('Successfully sent message:', response);
//     return { success: true, messageId: response };
//   } catch (error) {
//     console.error('Error sending message:', error);
//     throw new functions.https.HttpsError('internal', 'Failed to send notification', error);
//   }
// });
