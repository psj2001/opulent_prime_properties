const admin = require('firebase-admin');

// Initialize Firebase Admin with explicit project ID
// This will use the default credentials from the Firebase project
admin.initializeApp({
  projectId: 'opulent-prime-app',
});

const db = admin.firestore();
const auth = admin.auth();

/**
 * Creates an admin user account
 * Usage: node create_admin.js <email> <password> <name>
 */
async function createAdminAccount(email, password, name) {
  try {
    console.log(`Creating admin account for: ${email}`);
    
    // Step 1: Create user in Firebase Authentication
    let userRecord;
    try {
      userRecord = await auth.createUser({
        email: email,
        password: password,
        emailVerified: true, // Set email as verified
      });
      console.log(`✓ User created in Firebase Auth with UID: ${userRecord.uid}`);
    } catch (error) {
      if (error.code === 'auth/email-already-exists') {
        console.log(`⚠ User with email ${email} already exists in Firebase Auth`);
        // Get the existing user
        userRecord = await auth.getUserByEmail(email);
        console.log(`✓ Found existing user with UID: ${userRecord.uid}`);
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
      console.log(`✓ Updated existing user document with admin privileges`);
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
      console.log(`✓ Created user document in Firestore with admin privileges`);
    }
    
    console.log('\n✅ Admin account created successfully!');
    console.log(`   Email: ${email}`);
    console.log(`   UID: ${userRecord.uid}`);
    console.log(`   Name: ${name || 'Admin User'}`);
    console.log(`   Admin: true`);
    
    return userRecord.uid;
  } catch (error) {
    console.error('❌ Error creating admin account:', error);
    throw error;
  }
}

// Get command line arguments
const args = process.argv.slice(2);

if (args.length < 2) {
  console.error('Usage: node create_admin.js <email> <password> [name]');
  console.error('Example: node create_admin.js admin@example.com password123 "Admin Name"');
  process.exit(1);
}

const email = args[0];
const password = args[1];
const name = args[2] || 'Admin User';

// Run the script
createAdminAccount(email, password, name)
  .then(() => {
    console.log('\n✨ Done!');
    process.exit(0);
  })
  .catch((error) => {
    console.error('\n❌ Failed to create admin account:', error.message);
    process.exit(1);
  });

