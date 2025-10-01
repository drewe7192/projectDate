import { onCall, CallableRequest, HttpsError } from "firebase-functions/v2/https";
import * as functions from "firebase-functions";
import axios from "axios";
import jwt from "jsonwebtoken";

const hmsTemplateId = "638d9d1b2b58471af0e13f08"; // your template ID

export const createRoom = onCall(async (request: CallableRequest) => {
  // Require authenticated caller
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "The function must be called while authenticated.");
  }

  // Load HMS keys from Firebase config (set with: firebase functions:config:set hms.access_key="..." hms.secret="...")
  const hmsKey = functions.config().hms.access_key;
  const hmsSecret = functions.config().hms.secret;

  if (!hmsKey || !hmsSecret) {
    throw new HttpsError("internal", "Missing HMS access key or secret in Firebase config.");
  }

  // Generate short-lived management token
  const hmsManagementToken = jwt.sign(
    {
      access_key: hmsKey,
      type: "management",
      version: 2,
      iat: Math.floor(Date.now() / 1000),
      nbf: Math.floor(Date.now() / 1000),
      exp: Math.floor(Date.now() / 1000) + 60, // valid for 60s
    },
    hmsSecret,
    { algorithm: "HS256" }
  );

  const userId = request.auth.uid;
  const roomName = `room-${userId}`;

  try {
    // Create the room
    const createRoomResponse = await axios.post(
      "https://api.100ms.live/v2/rooms",
      {
        name: roomName,
        template_id: hmsTemplateId,
        description: `Room for user ${userId}`,
      },
      {
        headers: {
          Authorization: `Bearer ${hmsManagementToken}`,
          "Content-Type": "application/json",
        },
      }
    );

    const roomId = createRoomResponse.data.id;

    // Create room codes
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

    return { roomCode };
  } catch (error: any) {
    console.error("Error creating 100ms room:", error.message, error.response?.data);
    throw new HttpsError("internal", "Failed to create 100ms room.", error.message);
  }
});
