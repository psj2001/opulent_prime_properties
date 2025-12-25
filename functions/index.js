const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

const db = admin.firestore();

/**
 * Creates a lead when a consultation is booked
 * Triggered when a new consultation document is created
 */
exports.onCreateConsultation = functions.firestore
  .document('consultations/{consultationId}')
  .onCreate(async (snap, context) => {
    const consultation = snap.data();
    const consultationId = context.params.consultationId;
    
    try {
      // Create lead document
      const leadData = {
        userId: consultation.userId,
        source: 'consultation',
        status: 'new',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      };
      
      await db.collection('leads').add(leadData);
      
      // Admin notification will be sent by onCreateLead trigger
      
      console.log(`Lead created for consultation: ${consultationId}`);
      return null;
    } catch (error) {
      console.error('Error creating lead:', error);
      throw error;
    }
  });

/**
 * Creates a lead for a consultation (callable function - backup method)
 * Can be called from client if trigger function fails
 */
exports.createLeadForConsultation = functions.https.onCall(async (data, context) => {
  // Verify user is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'User must be authenticated'
    );
  }
  
  const { consultationId, userId } = data;
  
  if (!consultationId || !userId) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Missing consultationId or userId'
    );
  }
  
  // Verify the consultation exists and belongs to the user
  const consultationDoc = await db.collection('consultations').doc(consultationId).get();
  if (!consultationDoc.exists) {
    throw new functions.https.HttpsError(
      'not-found',
      'Consultation not found'
    );
  }
  
  const consultation = consultationDoc.data();
  // Verify the consultation belongs to the authenticated user
  if (consultation.userId !== context.auth.uid) {
    throw new functions.https.HttpsError(
      'permission-denied',
      'Not authorized to create lead for this consultation'
    );
  }
  
  // Ensure userId matches
  if (consultation.userId !== userId) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'userId does not match consultation'
    );
  }
  
  try {
    // Check if lead already exists for this consultation
    const existingLeads = await db.collection('leads')
      .where('userId', '==', userId)
      .where('source', '==', 'consultation')
      .get();
    
    // Check if there's already a lead created recently (within last 5 minutes)
    const now = admin.firestore.Timestamp.now();
    const fiveMinutesAgo = admin.firestore.Timestamp.fromMillis(now.toMillis() - 5 * 60 * 1000);
    
    const recentLead = existingLeads.docs.find(doc => {
      const leadData = doc.data();
      return leadData.createdAt && leadData.createdAt.toMillis() > fiveMinutesAgo.toMillis();
    });
    
    if (recentLead) {
      console.log(`Lead already exists for consultation: ${consultationId}`);
      return { success: true, leadId: recentLead.id, alreadyExists: true };
    }
    
    // Create lead document
    const leadData = {
      userId: userId,
      source: 'consultation',
      status: 'new',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    };
    
    const leadRef = await db.collection('leads').add(leadData);
    
    // Admin notification will be sent by onCreateLead trigger
    
    console.log(`Lead created for consultation: ${consultationId}, leadId: ${leadRef.id}`);
    return { success: true, leadId: leadRef.id };
  } catch (error) {
    console.error('Error creating lead:', error);
    throw new functions.https.HttpsError(
      'internal',
      'Failed to create lead'
    );
  }
});

/**
 * Creates a lead when a shortlist is shared
 * Called from client via callable function
 */
exports.shareShortlist = functions.https.onCall(async (data, context) => {
  // Verify user is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'User must be authenticated'
    );
  }
  
  const { userId, opportunityIds } = data;
  
  if (!userId || !opportunityIds || !Array.isArray(opportunityIds)) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Missing required fields'
    );
  }
  
  try {
    // Create lead document
    const leadData = {
      userId: userId,
      source: 'shortlist',
      status: 'new',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    };
    
    const leadRef = await db.collection('leads').add(leadData);
    
    // Admin notification will be sent by onCreateLead trigger
    
    // Generate shareable link (you can customize this)
    const shareLink = `https://yourapp.com/shortlist/${leadRef.id}`;
    
    return { success: true, shareLink, leadId: leadRef.id };
  } catch (error) {
    console.error('Error sharing shortlist:', error);
    throw new functions.https.HttpsError(
      'internal',
      'Failed to share shortlist'
    );
  }
});

/**
 * Gets all admin users
 * Helper function to retrieve all admin users from Firestore
 */
async function getAllAdmins() {
  try {
    const adminUsers = await db.collection('users')
      .where('isAdmin', '==', true)
      .get();
    
    return adminUsers.docs.map(doc => ({
      userId: doc.id,
      ...doc.data()
    }));
  } catch (error) {
    console.error('Error getting admin users:', error);
    return [];
  }
}

/**
 * Sends notification to user
 * Helper function for sending notifications
 */
async function sendNotification(userId, title, body, type) {
  try {
    // Get user's FCM token
    const userDoc = await db.collection('users').doc(userId).get();
    if (!userDoc.exists) {
      console.log(`User not found: ${userId}`);
      return;
    }
    
    const userData = userDoc.data();
    const fcmToken = userData ? userData.fcmToken : null;
    
    // Create notification document (even if no FCM token, so it appears in app)
    await db.collection('notifications').add({
      userId: userId,
      title: title,
      body: body,
      type: type,
      isRead: false,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    
    // Send FCM notification if token exists
    if (fcmToken) {
      const message = {
        notification: {
          title: title,
          body: body,
        },
        token: fcmToken,
      };
      
      await admin.messaging().send(message);
      console.log(`FCM notification sent to user: ${userId}`);
    } else {
      console.log(`Notification document created for user: ${userId} (no FCM token)`);
    }
  } catch (error) {
    console.error('Error sending notification:', error);
  }
}

/**
 * Notifies all admin users
 * Helper function to send notifications to all admins
 */
async function notifyAllAdmins(title, body, type) {
  try {
    const admins = await getAllAdmins();
    
    if (admins.length === 0) {
      console.log('No admin users found');
      return;
    }
    
    console.log(`Notifying ${admins.length} admin(s) about new lead`);
    
    // Send notification to each admin
    const notificationPromises = admins.map(admin => 
      sendNotification(admin.userId, title, body, type)
    );
    
    await Promise.all(notificationPromises);
    console.log(`Notifications sent to all admins`);
  } catch (error) {
    console.error('Error notifying admins:', error);
  }
}

/**
 * Sends booking confirmation notification
 * Triggered when consultation status changes to 'confirmed'
 */
exports.onConsultationConfirmed = functions.firestore
  .document('consultations/{consultationId}')
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();
    
    // Check if status changed to confirmed
    if (before.status !== 'confirmed' && after.status === 'confirmed') {
      await sendNotification(
        after.userId,
        'Consultation Confirmed',
        'Your consultation has been confirmed. We look forward to meeting you!',
        'consultation_confirmed'
      );
    }
    
    return null;
  });

/**
 * Notifies admins when a new lead is created
 * Triggered when a new lead document is created
 * This ensures admins are notified regardless of how the lead was created
 */
exports.onCreateLead = functions.firestore
  .document('leads/{leadId}')
  .onCreate(async (snap, context) => {
    const lead = snap.data();
    const leadId = context.params.leadId;
    
    try {
      // Get user information for the lead
      let userName = 'Unknown User';
      try {
        const userDoc = await db.collection('users').doc(lead.userId).get();
        if (userDoc.exists) {
          const userData = userDoc.data();
          userName = userData.name || userData.email || 'Unknown User';
        }
      } catch (error) {
        console.error('Error fetching user data:', error);
      }
      
      // Determine source description
      const sourceDescription = lead.source === 'consultation' 
        ? 'consultation booking' 
        : lead.source === 'shortlist' 
        ? 'shared shortlist' 
        : lead.source || 'unknown source';
      
      // Send notification to all admins
      await notifyAllAdmins(
        'New Lead Created',
        `New lead from ${userName} (${sourceDescription}). Lead ID: ${leadId.substring(0, 8)}...`,
        'new_lead'
      );
      
      console.log(`Admin notification sent for new lead: ${leadId}`);
      return null;
    } catch (error) {
      console.error('Error notifying admins about new lead:', error);
      // Don't throw error - lead creation should still succeed
      return null;
    }
  });

/**
 * Assigns consultant to a lead
 * Called from admin panel
 */
exports.assignConsultant = functions.https.onCall(async (data, context) => {
  // Verify user is admin
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'User must be authenticated'
    );
  }
  
  // TODO: Check if user is admin (you'll need to implement this check)
  
  const { leadId, consultantId } = data;
  
  if (!leadId || !consultantId) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Missing leadId or consultantId'
    );
  }
  
  try {
    // Update lead with consultant assignment
    await db.collection('leads').doc(leadId).update({
      consultantId: consultantId,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    
    // Get lead data to send notification
    const leadDoc = await db.collection('leads').doc(leadId).get();
    const leadData = leadDoc.data();
    
    // Send notification to user
    await sendNotification(
      leadData.userId,
      'Consultant Assigned',
      'A consultant has been assigned to assist you.',
      'consultant_assigned'
    );
    
    return { success: true };
  } catch (error) {
    console.error('Error assigning consultant:', error);
    throw new functions.https.HttpsError(
      'internal',
      'Failed to assign consultant'
    );
  }
});

/**
 * Sends notification to a user (admin function)
 * Called from admin panel to send custom notifications
 */
exports.sendNotificationToUser = functions.https.onCall(async (data, context) => {
  // Verify user is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'User must be authenticated'
    );
  }
  
  // Verify user is admin
  const adminUserDoc = await db.collection('users').doc(context.auth.uid).get();
  if (!adminUserDoc.exists || !adminUserDoc.data()?.isAdmin) {
    throw new functions.https.HttpsError(
      'permission-denied',
      'Only admins can send notifications'
    );
  }
  
  const { userId, title, body, type } = data;
  
  if (!userId || !title || !body) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Missing required fields: userId, title, and body are required'
    );
  }
  
  try {
    await sendNotification(userId, title, body, type || 'admin_notification');
    return { success: true };
  } catch (error) {
    console.error('Error sending notification:', error);
    throw new functions.https.HttpsError(
      'internal',
      'Failed to send notification'
    );
  }
});

/**
 * Creates an admin user account
 * WARNING: This function should be protected or removed after creating the initial admin
 * Usage: Call this function with { email, password, name } to create an admin account
 * 
 * For security, you may want to:
 * 1. Remove this function after creating your admin account
 * 2. Add additional authentication/authorization checks
 * 3. Use this only in development or with proper security measures
 */
exports.createAdminAccount = functions.https.onCall(async (data, context) => {
  const { email, password, name } = data;
  
  if (!email || !password) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Email and password are required'
    );
  }
  
  try {
    // Step 1: Create user in Firebase Authentication
    let userRecord;
    try {
      userRecord = await admin.auth().createUser({
        email: email,
        password: password,
        emailVerified: true,
      });
      console.log(`User created in Firebase Auth with UID: ${userRecord.uid}`);
    } catch (error) {
      if (error.code === 'auth/email-already-exists') {
        console.log(`User with email ${email} already exists in Firebase Auth`);
        userRecord = await admin.auth().getUserByEmail(email);
        console.log(`Found existing user with UID: ${userRecord.uid}`);
      } else {
        throw error;
      }
    }
    
    // Step 2: Create or update user document in Firestore with admin privileges
    const now = admin.firestore.Timestamp.now();
    const userDocRef = db.collection('users').doc(userRecord.uid);
    
    const userDoc = await userDocRef.get();
    
    if (userDoc.exists) {
      // Update existing user document to set isAdmin to true
      await userDocRef.update({
        isAdmin: true,
        updatedAt: now,
        email: email,
        name: name || userDoc.data().name || 'Admin User',
      });
      console.log(`Updated existing user document with admin privileges`);
    } else {
      // Create new user document with admin privileges
      await userDocRef.set({
        userId: userRecord.uid,
        email: email,
        name: name || 'Admin User',
        createdAt: now,
        updatedAt: now,
        isAdmin: true,
      });
      console.log(`Created user document in Firestore with admin privileges`);
    }
    
    return {
      success: true,
      uid: userRecord.uid,
      email: email,
      name: name || 'Admin User',
      message: 'Admin account created successfully'
    };
  } catch (error) {
    console.error('Error creating admin account:', error);
    throw new functions.https.HttpsError(
      'internal',
      `Failed to create admin account: ${error.message}`
    );
  }
});

