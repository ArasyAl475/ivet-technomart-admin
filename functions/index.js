const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Initialize Firebase Admin SDK
admin.initializeApp();


// --------------- Import functions ---------------
const { addAdminRole } = require("./authentication/set_admin");
const { registerUser } = require("./authentication/register_auth_user");
const { deleteUserByEmail } = require("./authentication/delete_auth_user");

exports.authentication = { addAdminRole, registerUser, deleteUserByEmail };


//  --------------- Import notification functions ---------------
const { sendNotifications } = require('./notifications/order_notifications');

exports.sendNotification = sendNotifications;



// --------------- Import stats functions from different modules ---------------
const updateOrderStats = require('./stats/orders_stats');
//const updateProductStats = require('./stats/products_stats');
//const updateRetailerStats  = require('./stats/retailers_stats');
//const updateUserStats  = require('./stats/users_stats');
//const updateCategoryStats  = require('./stats/categories_stats');
//const updateBrandStats = require('./stats/brands_stats');


// Export all the functions
exports.updateOrderStats = updateOrderStats;
//exports.CategoryStats = updateCategoryStats;
//exports.updateProductStats = updateProductStats;
//exports.updateRetailerStats = updateRetailerStats;
//exports.updateUserStats = updateUserStats;
//exports.updateBrandStats = updateBrandStats;


// --------------- Import SMS handlers ---------------
const { sendOtpHandler } = require("./sms_authentication/send_otp");
const { verifyOtpHandler } = require("./sms_authentication/verify_otp");

exports.infoBip = {sendOtpHandler, verifyOtpHandler};


// --------------- Stripe ---------------
const { createStripePaymentIntent } = require("./stripe/payment_intent");
exports.createStripePaymentIntent = createStripePaymentIntent;



