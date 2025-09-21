import { onCall, CallableRequest, HttpsError } from "firebase-functions/v2/https";
import * as admin from 'firebase-admin';

// Helper function to send notifications via FCM
async function sendNotification(fcmToken: string, title: string, body: string, data: { [key: string]: string }) {
    if (!fcmToken) {
        throw new HttpsError('invalid-argument', 'FCM token is required.');
    }

    const message = {
        notification: {
            title: title,
            body: body,
        },
        token: fcmToken,
        data: data,
    };

    try {
        const response = await admin.messaging().send(message);
        console.log('Successfully sent message:', response);
        return { success: true, messageId: response };
    } catch (error: any) {
        console.error('Error sending message:', error);
        throw new HttpsError('internal', 'Failed to send notification', error.message);
    }
}

// -----------------------------------------------------------------------------
// Exported Callable Functions
// -----------------------------------------------------------------------------

export const sendRequestNotification = onCall(async (request: CallableRequest) => {
    const { fcmToken, requestByProfileId, requestByProfileName, requestByProfileGender, requestByProfileRoomCode, requestByProfileUserId } = request.data;
    
    if (!fcmToken || !requestByProfileId) {
        throw new HttpsError('invalid-argument', 'Missing required parameters.');
    }

    const data = {
        'requestByProfileId': requestByProfileId,
        'requestByProfileName': requestByProfileName,
        'requestByProfileGender': requestByProfileGender,
        'requestByProfileRoomCode': requestByProfileRoomCode,
        'requestByProfileUserId': requestByProfileUserId,
    };

    return sendNotification(fcmToken, 'BlindChat Request', 'Someone sent you a request', data);
});

export const sendAcceptNotification = onCall(async (request: CallableRequest) => {
    const { fcmToken, isRequestAccepted } = request.data;
    if (!fcmToken) {
        throw new HttpsError('invalid-argument', 'Missing FCM token.');
    }
    const data = { 'isRequestAccepted': String(isRequestAccepted) };
    return sendNotification(fcmToken, 'Request Accepted!', 'Starting BlindChat with user in 5 seconds', data);
});

export const sendDeclineNotification = onCall(async (request: CallableRequest) => {
    const { fcmToken, isRequestAccepted } = request.data;
    if (!fcmToken) {
        throw new HttpsError('invalid-argument', 'Missing FCM token.');
    }
    const data = { 'isRequestAccepted': String(isRequestAccepted) };
    return sendNotification(fcmToken, 'Request Declined', 'Sorry, someone denied your request', data);
});

export const sendHostAnswerNotification = onCall(async (request: CallableRequest) => {
    const { fcmToken, answer } = request.data;
    if (!fcmToken) {
        throw new HttpsError('invalid-argument', 'Missing FCM token.');
    }
    const data = { 'hostAnswer': answer };
    return sendNotification(fcmToken, 'Received Host Answer', 'Waiting on response from guest', data);
});

export const sendGuestAnswerNotification = onCall(async (request: CallableRequest) => {
    const { fcmToken, answer } = request.data;
    if (!fcmToken) {
        throw new HttpsError('invalid-argument', 'Missing FCM token.');
    }
    const data = { 'guestAnswer': answer };
    return sendNotification(fcmToken, 'Received Guest Answer', 'Waiting on response from host', data);
});
