import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminServices extends StatefulWidget {
  const AdminServices({super.key});

  @override
  State<AdminServices> createState() => _AdminServicesState();
}

class _AdminServicesState extends State<AdminServices> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Services")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Service Name")),
                TextField(controller: _priceController, decoration: const InputDecoration(labelText: "Price"), keyboardType: TextInputType.number),
                TextField(controller: _durationController, decoration: const InputDecoration(labelText: "Duration (mins)"), keyboardType: TextInputType.number),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const Text("Add Service"),
                  onPressed: () async {
                    await _firestore.collection("services").add({
                      'name': _nameController.text.trim(),
                      'price': int.parse(_priceController.text.trim()),
                      'duration': int.parse(_durationController.text.trim()),
                    });
                    _nameController.clear();
                    _priceController.clear();
                    _durationController.clear();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection("services").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final services = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return ListTile(
                      title: Text(service['name']),
                      subtitle: Text("Price: ₹${service['price']} | ${service['duration']} mins"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await _firestore.collection("services").doc(service.id).delete();
                        },
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
