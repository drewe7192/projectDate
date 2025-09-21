import { onCall, CallableRequest, HttpsError } from "firebase-functions/v2/https";
import axios from 'axios';

const hmsTemplateId = '638d9d1b2b58471af0e13f08'; 

export const createRoom = onCall(async (request: CallableRequest) => {
    // Get the secret securely from environment variables.
    const hmsManagementToken = process.env.HMS_MANAGEMENT_TOKEN;

    // Check for authenticated user and a valid token.
    if (!request.auth) {
        throw new HttpsError('unauthenticated', 'The function must be called while authenticated.');
    }
    if (!hmsManagementToken) {
        throw new HttpsError('internal', 'Missing HMS_MANAGEMENT_TOKEN environment variable.');
    }

    const userId = request.auth.uid;
    const roomName = `room-${userId}`;
    console.log('Userid',userId);
    try {
        // Call the 100ms Create Room API
        const createRoomResponse = await axios.post(
            'https://api.100ms.live/v2/rooms',
            {
                name: roomName,
                template_id: hmsTemplateId,
                description: `Room for new user ${userId}`,
            },
            {
                headers: {
                    Authorization: `Bearer ${hmsManagementToken}`,
                    'Content-Type': 'application/json',
                },
            }
        );
        const roomId = createRoomResponse.data.id;

        // Call the 100ms Create Room Codes API
        const createRoomCodeResponse = await axios.post(
            `https://api.100ms.live/v2/room-codes/room/${roomId}`,
            {},
            {
                headers: {
                    Authorization: `Bearer ${hmsManagementToken}`,
                },
            }
        );
        const roomCode = createRoomCodeResponse.data.data[0].code;

        return { roomCode: roomCode };
    } catch (error: any) {
        console.error('Error creating 100ms room:', error.message);
        throw new HttpsError('internal', 'Failed to create 100ms room.', error.message);
    }
});
