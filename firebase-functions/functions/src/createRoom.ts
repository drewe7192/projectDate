import { onCall, HttpsError } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";
import axios from "axios";
import jwt from "jsonwebtoken";

const hmsTemplateId = "638d9d1b2b58471af0e13f08"; // your template ID
const hmsAccessKey = defineSecret("HMS_ACCESS_KEY");
const hmsSecret = defineSecret("HMS_SECRET");

export const createRoom = onCall(
  { secrets: [hmsAccessKey, hmsSecret] },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Must be called while authenticated.");
    }

    const hmsKey = hmsAccessKey.value();
    const hmsSecretKey = hmsSecret.value();

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
    hmsSecretKey,
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
