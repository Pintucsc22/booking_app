import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminBookings extends StatelessWidget {
  const AdminBookings({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(title: const Text("All Bookings")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection("bookings").orderBy('date', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final bookings = snapshot.data!.docs;

          if (bookings.isEmpty) return const Center(child: Text("No bookings found"));

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text("${booking['serviceName']} - ${booking['userName']}"),
                  subtitle: Text(
                      "Phone: ${booking['userPhone'] ?? '-'}\nDate: ${booking['date'].toDate().toLocal().toString().split(' ')[0]} | Time: ${booking['time']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (booking['status'] == "Pending")
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () async {
                            await _firestore
                                .collection("bookings")
                                .doc(booking.id)
                                .update({'status': "Done"});
                          },
                        ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await _firestore.collection("bookings").doc(booking.id).delete();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
