import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Create default Super Admin if not exists
  await createDefaultSuperAdmin();

  runApp(const SalonApp());
}

// Function to create default Super Admin
Future<void> createDefaultSuperAdmin() async {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final superAdminEmail = dotenv.env['SUPER_ADMIN_EMAIL'] ?? '';
  final superAdminPassword = dotenv.env['SUPER_ADMIN_PASSWORD'] ?? '';

  if (superAdminEmail.isEmpty || superAdminPassword.isEmpty) {
    print("SUPER_ADMIN_EMAIL or SUPER_ADMIN_PASSWORD is missing in .env");
    return;
  }

  try {
    // Check if Super Admin exists in Firestore
    var userQuery = await _firestore
        .collection('users')
        .where('email', isEqualTo: superAdminEmail)
        .get();

    if (userQuery.docs.isEmpty) {
      try {
        // Create user in Firebase Auth
        UserCredential userCred = await _auth.createUserWithEmailAndPassword(
          email: superAdminEmail,
          password: superAdminPassword,
        );

        // Add Firestore doc
        await _firestore.collection('users').doc(userCred.user!.uid).set({
          'name': 'Super Admin',
          'email': superAdminEmail,
          'role': 'super_admin',
          'status': 'approved',
        });

        print("Default Super Admin created in Auth & Firestore");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          // Auth user exists, create Firestore doc if missing
          var existingUser = await _auth.signInWithEmailAndPassword(
            email: superAdminEmail,
            password: superAdminPassword,
          );

          // Use set with merge:true to avoid overwriting
          await _firestore
              .collection('users')
              .doc(existingUser.user!.uid)
              .set({
            'name': 'Super Admin',
            'email': superAdminEmail,
            'role': 'super_admin',
            'status': 'approved',
          }, SetOptions(merge: true));

          print("Firestore document for Super Admin created");
        } else {
          rethrow;
        }
      }
    } else {
      print("Super Admin already exists in Firestore, skipping creation");
    }
  } catch (e) {
    print("Error creating Super Admin: $e");
  }
}

class SalonApp extends StatelessWidget {
  const SalonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salon Booking App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const SplashScreen(),
    );
  }
}
