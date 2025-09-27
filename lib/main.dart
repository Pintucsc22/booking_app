import 'package:flutter/material.dart';
import 'customer_login.dart';
// import 'admin_login.dart';

void main() {
  runApp(const BookingApp());
}

class BookingApp extends StatelessWidget {
  const BookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const HomePage(), // ✅ Correct place
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
          mainAxisAlignment: MainAxisAlignment.center, // center children vertically
          children: [
            const Icon(Icons.spa, size: 200, color: Colors.pink),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Booking App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.person),
              label: const Text('Login as User'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                minimumSize: const Size(220, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomerLogin()
                  ),
                );
              }
            ),
            // const SizedBox(height:20),
            // ElevatedButton.icon(
            //   icon: const Icon(Icons.store),
            //   label: const Text("Login as a Admin"),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor:Colors.black,
            //     minimumSize: const Size(220,50)
            //   ),
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const AdminLogin()
            //       ),
            //     );
            //   }
            // )
          ],
        ),
      ),
    );
  }
}
