import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'customer_login.dart';
import 'admin_login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBRPFfNePNv6J-MuRMkIElV8wBrIF_GyO0",
      authDomain: "booking-9fdab.firebaseapp.com",
      projectId: "booking-9fdab",
      storageBucket: "booking-9fdab.appspot.com",
      messagingSenderId: "345513757283",
      appId: "1:345513757283:web:08292fe845b194dc8f8656",
    ),
  );

  runApp(const SalonApp());
}

class SalonApp extends StatelessWidget {
  const SalonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Salon App',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.spa, size: 200, color: Colors.pink),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Salon App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.person),
              label: const Text('Login as Customer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                minimumSize: const Size(220, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomerLogin(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.store),
              label: const Text("Login as Admin"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(220, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminLogin(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
