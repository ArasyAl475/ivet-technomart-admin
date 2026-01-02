const { onRequest } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
const crypto = require('crypto');
const { defineSecret } = require('firebase-functions/params'); // Import this

const midtransServerKey = defineSecret('MIDTRANS_SERVER_KEY'); // Define it

exports.handleMidtransWebhook = onRequest(
    { region: "us-central1", secrets: [midtransServerKey] },
    async (req, res) => {
        try {
            const notificationJson = req.body;

            const orderId = notificationJson.order_id;
            const transactionStatus = notificationJson.transaction_status;
            const fraudStatus = notificationJson.fraud_status;

            console.log(`Midtrans Notification: ${orderId} status: ${transactionStatus}`);

            // 1. Verify Signature
            const serverKey = midtransServerKey.value();
            const signatureKey = notificationJson.signature_key;
            const statusCode = notificationJson.status_code;
            const grossAmount = notificationJson.gross_amount;

            const hash = crypto.createHash('sha512')
                .update(orderId + statusCode + grossAmount + serverKey)
                .digest('hex');

            if (hash !== signatureKey) {
                console.error("Invalid Midtrans Signature");
                return res.status(403).send("Invalid signature");
            }

            // 2. Determine Payment Status
            let newStatus = 'pending'; // default

            if (transactionStatus == 'capture') {
                if (fraudStatus == 'challenge') {
                    newStatus = 'pending';
                } else if (fraudStatus == 'accept') {
                    newStatus = 'paid';
                }
            } else if (transactionStatus == 'settlement') {
                newStatus = 'paid';
            } else if (transactionStatus == 'cancel' || transactionStatus == 'deny' || transactionStatus == 'expire') {
                newStatus = 'failed';
            }

            // 3. Update Firestore (CRITICAL FIX: Check "Orders" vs "orders")
            await updateOrderStatus(orderId, newStatus, notificationJson);

            res.status(200).send('OK');
        } catch (err) {
            console.error("Webhook Error:", err);
            res.status(400).send(`Webhook Error: ${err.message}`);
        }
    }
);

async function updateOrderStatus(orderId, status, data) {
    const db = admin.firestore();

    // CORRECT: strictly use "Orders" with Capital O
    const orderRef = db.collection("Orders").doc(orderId);

    const doc = await orderRef.get();

    if (!doc.exists) {
        // Log the error clearly so we know if the ID is wrong or Collection is wrong
        console.error(`CRITICAL ERROR: Order ${orderId} not found in 'Orders' collection.`);
        throw new Error(`Order ${orderId} not found`);
    }

    await orderRef.update({
        paymentStatus: status,
        paymentMethod: data.payment_type,
        amountCaptured: parseFloat(data.gross_amount),
        updatedAt: admin.firestore.FieldValue.serverTimestamp()
    });

    console.log(`Successfully updated Order ${orderId} in 'Orders' collection to ${status}`);
}