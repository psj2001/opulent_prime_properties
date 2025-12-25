const admin = require('firebase-admin');

// Initialize Firebase Admin with explicit project ID
admin.initializeApp({
  projectId: 'opulent-prime-app',
});

const db = admin.firestore();
const auth = admin.auth();

/**
 * Fixes admin account by ensuring Firebase Auth user exists and Firestore document matches
 * Usage: node fix_admin_account.js <email> <password>
 */
async function fixAdminAccount(email, password) {
  try {
    console.log(`Fixing admin account for: ${email}`);
    
    // Step 1: Check if user exists in Firebase Auth
    let userRecord;
    try {
      userRecord = await auth.getUserByEmail(email);
      console.log(`✓ User exists in Firebase Auth with UID: ${userRecord.uid}`);
    } catch (error) {
      if (error.code === 'auth/user-not-found') {
        console.log(`⚠ User not found in Firebase Auth, creating...`);
        // Create user in Firebase Auth
        userRecord = await auth.createUser({
          email: email,
          password: password,
          emailVerified: true,
        });
        console.log(`✓ User created in Firebase Auth with UID: ${userRecord.uid}`);
      } else {
        throw error;
      }
    }
    
    const correctUid = userRecord.uid;
    console.log(`\nCorrect UID from Firebase Auth: ${correctUid}`);
    
    // Step 2: Check Firestore document
    const userDocRef = db.collection('users').doc(correctUid);
    const userDoc = await userDocRef.get();
    
    if (userDoc.exists) {
      const userData = userDoc.data();
      console.log(`✓ Firestore document exists with correct UID`);
      console.log(`  Current isAdmin: ${userData.isAdmin}`);
      
      // Ensure isAdmin is true
      if (!userData.isAdmin) {
        await userDocRef.update({
          isAdmin: true,
          updatedAt: admin.firestore.Timestamp.now(),
        });
        console.log(`✓ Updated isAdmin to true`);
      }
    } else {
      console.log(`⚠ Firestore document doesn't exist with correct UID`);
      
      // Check if there's a document with wrong UID (by email)
      const usersWithEmail = await db.collection('users')
        .where('email', '==', email)
        .get();
      
      if (!usersWithEmail.empty) {
        console.log(`⚠ Found ${usersWithEmail.size} document(s) with this email but wrong UID`);
        for (const doc of usersWithEmail.docs) {
          console.log(`  - Document ID: ${doc.id} (should be: ${correctUid})`);
          
          // Copy data from old document
          const oldData = doc.data();
          
          // Create new document with correct UID
          const now = admin.firestore.Timestamp.now();
          await userDocRef.set({
            userId: correctUid,
            email: email,
            name: oldData.name || 'Admin User',
            phone: oldData.phone || null,
            createdAt: oldData.createdAt || now,
            updatedAt: now,
            isAdmin: true,
            fcmToken: oldData.fcmToken || null,
          });
          console.log(`✓ Created new document with correct UID`);
          
          // Optionally delete old document
          // await doc.ref.delete();
          // console.log(`✓ Deleted old document with wrong UID`);
        }
      } else {
        // Create new document
        const now = admin.firestore.Timestamp.now();
        await userDocRef.set({
          userId: correctUid,
          email: email,
          name: 'Admin User',
          createdAt: now,
          updatedAt: now,
          isAdmin: true,
        });
        console.log(`✓ Created new Firestore document with correct UID`);
      }
    }
    
    console.log('\n✅ Admin account fixed successfully!');
    console.log(`   Email: ${email}`);
    console.log(`   UID: ${correctUid}`);
    console.log(`   Admin: true`);
    console.log(`\nYou can now log in with:`);
    console.log(`   Email: ${email}`);
    console.log(`   Password: ${password}`);
    
    return correctUid;
  } catch (error) {
    console.error('❌ Error fixing admin account:', error);
    throw error;
  }
}

// Get command line arguments
const args = process.argv.slice(2);

if (args.length < 2) {
  console.error('Usage: node fix_admin_account.js <email> <password>');
  console.error('Example: node fix_admin_account.js pranavputhoor91@gmail.com 123456');
  process.exit(1);
}

const email = args[0];
const password = args[1];

// Run the script
fixAdminAccount(email, password)
  .then(() => {
    console.log('\n✨ Done!');
    process.exit(0);
  })
  .catch((error) => {
    console.error('\n❌ Failed to fix admin account:', error.message);
    process.exit(1);
  });

