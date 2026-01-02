const { onCall, HttpsError } = require("firebase-functions/v2/https");
const midtransClient = require('midtrans-client');
const { defineSecret } = require('firebase-functions/params');

const midtransServerKey = defineSecret('MIDTRANS_SERVER_KEY');

exports.createMidtransTransaction = onCall(
    { region: "us-central1", memory: "256MiB", secrets: [midtransServerKey] },
    async (request) => {
        // Initialize client with secret
        let snap = new midtransClient.Snap({
            isProduction: false,
            serverKey: midtransServerKey.value()
        });

        console.log("Midtrans Triggered", { uid: request.auth?.uid });
        try {
            // 1. Authentication check
            if (!request.auth) {
                throw new HttpsError("unauthenticated", "User must be authenticated");
            }

            // 2. Input validation
            const { amount, orderId, userDetails } = request.data;
            if (typeof amount !== "number" || !orderId) {
                throw new HttpsError("invalid-argument", "Missing amount or Order ID");
            }

            // 3. Create Snap Parameter
            let parameter = {
                "transaction_details": {
                    "order_id": orderId,
                    "gross_amount": Math.round(amount)
                },
                "credit_card": {
                    "secure": true
                },
                "customer_details": {
                    "first_name": userDetails?.name || "Customer",
                    "email": userDetails?.email || "",
                    "phone": userDetails?.phone || ""
                }
            };

            // 4. Create Transaction
            console.log("Creating Midtrans token", parameter);
            const transaction = await snap.createTransaction(parameter);

            console.log("Midtrans Token created", { token: transaction.token });

            // 5. Return Snap Token
            return { snapToken: transaction.token, redirectUrl: transaction.redirect_url };

        } catch (error) {
            console.error("Error in createMidtransTransaction", error);
            // Use HttpsError directly
            throw new HttpsError("internal", error.message || "Internal Server Error");
        }
    }
);