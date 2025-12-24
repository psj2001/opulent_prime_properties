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
      
      // Send notification to admin
      // TODO: Implement notification sending
      
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
 * Sends notification to user
 * Helper function for sending notifications
 */
async function sendNotification(userId, title, body, type) {
  try {
    // Get user's FCM token
    const userDoc = await db.collection('users').doc(userId).get();
    const userData = userDoc.data();
    const fcmToken = userData ? userData.fcmToken : null;
    
    if (!fcmToken) {
      console.log(`No FCM token for user: ${userId}`);
      return;
    }
    
    // Create notification document
    await db.collection('notifications').add({
      userId: userId,
      title: title,
      body: body,
      type: type,
      isRead: false,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    
    // Send FCM notification
    const message = {
      notification: {
        title: title,
        body: body,
      },
      token: fcmToken,
    };
    
    await admin.messaging().send(message);
    console.log(`Notification sent to user: ${userId}`);
  } catch (error) {
    console.error('Error sending notification:', error);
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

