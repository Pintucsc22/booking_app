import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerBooking extends StatefulWidget {
  final String serviceId;
  final String serviceName;
  final int price;
  final int duration; // in minutes

  const CustomerBooking({
    super.key,
    required this.serviceId,
    required this.serviceName,
    required this.price,
    required this.duration,
  });

  @override
  State<CustomerBooking> createState() => _CustomerBookingState();
}

class _CustomerBookingState extends State<CustomerBooking> {
  DateTime? selectedDate;
  String? selectedTime;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  List<String> generateTimeSlots(int duration) {
    List<String> slots = [];
    TimeOfDay start = const TimeOfDay(hour: 10, minute: 0);
    TimeOfDay end = const TimeOfDay(hour: 20, minute: 0);

    int totalMinutes =
        (end.hour - start.hour) * 60 + (end.minute - start.minute);
    int slotCount = totalMinutes ~/ duration;

    for (int i = 0; i < slotCount; i++) {
      int hour = start.hour + ((start.minute + i * duration) ~/ 60);
      int minute = (start.minute + i * duration) % 60;
      String time =
          "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
      slots.add(time);
    }
    return slots;
  }

  Future<List<String>> fetchBookedSlots(DateTime date) async {
    final snapshot = await _firestore
        .collection("bookings")
        .where("date",
            isEqualTo: DateTime(date.year, date.month, date.day)) // normalize
        .get();

    return snapshot.docs.map((doc) => doc["time"] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    final slots = generateTimeSlots(widget.duration);

    return Scaffold(
      appBar: AppBar(title: Text("Book ${widget.serviceName}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              child: const Text("Select Date"),
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                  initialDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                    selectedTime = null; // reset time when date changes
                  });
                }
              },
            ),
            if (selectedDate != null)
              Text("Selected Date: ${selectedDate!.toLocal().toString().split(' ')[0]}"),
            const SizedBox(height: 20),

            // --- Show slots with Firestore check ---
            if (selectedDate != null)
              FutureBuilder<List<String>>(
                future: fetchBookedSlots(selectedDate!),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final bookedSlots = snapshot.data!;
                  return Wrap(
                    spacing: 8,
                    children: slots.map((time) {
                      final isBooked = bookedSlots.contains(time);
                      return ChoiceChip(
                        label: Text(
                          time,
                          style: TextStyle(
                            color: isBooked ? Colors.grey : null,
                          ),
                        ),
                        selected: selectedTime == time,
                        onSelected: isBooked
                            ? null
                            : (_) {
                                setState(() {
                                  selectedTime = time;
                                });
                              },
                      );
                    }).toList(),
                  );
                },
              ),

            const SizedBox(height: 20),

            ElevatedButton(
              child: const Text("Confirm Booking (Cash Only)"),
              onPressed: selectedDate != null && selectedTime != null
                  ? () async {
                      // Check if slot already booked
                      final existing = await _firestore
                          .collection("bookings")
                          .where("date",
                              isEqualTo: DateTime(selectedDate!.year,
                                  selectedDate!.month, selectedDate!.day))
                          .where("time", isEqualTo: selectedTime)
                          .get();

                      if (existing.docs.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("This slot is already booked.")),
                        );
                        return;
                      }

                      // Save booking
                      await _firestore.collection("bookings").add({
                        'serviceId': widget.serviceId,
                        'serviceName': widget.serviceName,
                        'price': widget.price,
                        'userId': user!.uid,
                        'userName': user!.email,
                        'userPhone': "",
                        'date': DateTime(selectedDate!.year,
                            selectedDate!.month, selectedDate!.day),
                        'time': selectedTime,
                        'status': "Pending",
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Booking confirmed!")),
                      );
                      Navigator.pop(context);
                    }
                  : null,
            )
          ],
        ),
      ),
    );
  }
}
