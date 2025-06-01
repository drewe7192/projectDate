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

exports.sendRequestNotification = onCall(async(data: any, context: any) => {
    const fcmToken = data.data.fcmToken
    const requestByProfileId = data.data.requestByProfileId
    const requestByProfileName = data.data.requestByProfileName
    const requestByProfileGender = data.data.requestByProfileGender
    const requestByProfileRoomCode = data.data.requestByProfileRoomCode
    const requestByProfileUserId = data.data.requestByProfileUserId

    const message: any = {
    notification: {
      title: 'Hello from Firebase!',
      body: 'This is a test notification.',
    },
    token: fcmToken,
    data : {
        'requestByProfileId' : requestByProfileId,
        'requestByProfileName': requestByProfileName,
        'requestByProfileGender' : requestByProfileGender,
        'requestByProfileRoomCode' : requestByProfileRoomCode,
        'requestByProfileUserId' : requestByProfileUserId
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

exports.sendAcceptNotification = onCall(async(data: any, context: any) => {
    const fcmToken = data.data.fcmToken
    const isRequestAccepted = data.data.isRequestAccepted

    const message: any = {
    notification: {
      title: 'Request Accepted',
      body: 'Connecting now',
    },
    token: fcmToken,
    data : {
      'isRequestAccepted': isRequestAccepted
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

exports.sendDeclineNotification = onCall(async(data: any, context: any) => {
    const fcmToken = data.data.fcmToken
    const isRequestAccepted = data.data.isRequestAccepted

    const message: any = {
    notification: {
      title: 'Request Decline',
      body: 'You suck',
    },
    token: fcmToken,
    data : {
      'isRequestAccepted': isRequestAccepted
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

exports.sendHostAnswerNotification = onCall(async(data: any, context: any) => {
    const fcmToken = data.data.fcmToken
    const answer = data.data.answer

    const message: any = {
    notification: {
      title: 'Received Host Answer',
      body: 'Waiting on response from guest',
    },
    token: fcmToken,
    data : {
      'hostAnswer': answer
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

exports.sendGuestAnswerNotification = onCall(async(data: any, context: any) => {
    const fcmToken = data.data.fcmToken
    const answer = data.data.answer

    const message: any = {
    notification: {
       title: 'Received Guest Answer',
      body: 'Waiting on response from host',
    },
    token: fcmToken,
    data : {
      'guestAnswer': answer
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
