import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminApprovalPage extends StatefulWidget {
  const AdminApprovalPage({super.key});

  @override
  State<AdminApprovalPage> createState() => _AdminApprovalPageState();
}

class _AdminApprovalPageState extends State<AdminApprovalPage> {
  final _usersRef = FirebaseFirestore.instance.collection('users');

  // Approve a pending admin
  Future<void> approveAdmin(String userId) async {
    await _usersRef.doc(userId).update({
      'role': 'admin',
      'status': 'approved',
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Admin approved successfully!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pending Admin Approvals')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersRef.where('role', isEqualTo: 'pending_admin').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No pending admin requests.'));
          }

          final pendingAdmins = snapshot.data!.docs;

          return ListView.builder(
            itemCount: pendingAdmins.length,
            itemBuilder: (context, index) {
              final user = pendingAdmins[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(user['name']),
                  subtitle: Text(user['email']),
                  trailing: ElevatedButton(
                    onPressed: () => approveAdmin(user.id),
                    child: const Text('Approve'),
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
