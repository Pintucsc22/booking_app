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
    // salon working hours: 10:00 to 20:00
    List<String> slots = [];
    TimeOfDay start = const TimeOfDay(hour: 10, minute: 0);
    TimeOfDay end = const TimeOfDay(hour: 20, minute: 0);

    int totalMinutes = (end.hour - start.hour) * 60 + (end.minute - start.minute);
    int slotCount = totalMinutes ~/ duration;

    for (int i = 0; i < slotCount; i++) {
      int hour = start.hour + ((start.minute + i * duration) ~/ 60);
      int minute = (start.minute + i * duration) % 60;
      String time = "${hour.toString().padLeft(2,'0')}:${minute.toString().padLeft(2,'0')}";
      slots.add(time);
    }
    return slots;
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
                  });
                }
              },
            ),
            if (selectedDate != null)
              Text("Selected Date: ${selectedDate!.toLocal().toString().split(' ')[0]}"),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              children: slots.map((time) {
                return ChoiceChip(
                  label: Text(time),
                  selected: selectedTime == time,
                  onSelected: (_) {
                    setState(() {
                      selectedTime = time;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Confirm Booking (Cash Only)"),
              onPressed: selectedDate != null && selectedTime != null
                  ? () async {
                      await _firestore.collection("bookings").add({
                        'serviceId': widget.serviceId,
                        'serviceName': widget.serviceName,
                        'price': widget.price,
                        'userId': user!.uid,
                        'userName': user!.email,
                        'userPhone': "", // optional, extend later
                        'date': selectedDate,
                        'time': selectedTime,
                        'status': "Pending",
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Booking confirmed!")));
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
