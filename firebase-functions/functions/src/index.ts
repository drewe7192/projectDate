import * as admin from 'firebase-admin';
import * as notifications from './sendNotifications';
import * as createroom from './createRoom';

// Initialize the Firebase Admin SDK once globally at the top level
admin.initializeApp();

// Export the callable functions from your other files
exports.sendRequestNotification = notifications.sendRequestNotification;
exports.sendAcceptNotification = notifications.sendAcceptNotification;
exports.sendDeclineNotification = notifications.sendDeclineNotification;
exports.sendHostAnswerNotification = notifications.sendHostAnswerNotification;
exports.sendGuestAnswerNotification = notifications.sendGuestAnswerNotification;

exports.createRoom = createroom.createRoom;
