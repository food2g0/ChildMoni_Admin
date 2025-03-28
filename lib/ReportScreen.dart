import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  void _deleteReport(String reportId) {
    FirebaseFirestore.instance.collection('Report').doc(reportId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports'), backgroundColor: Colors.pinkAccent),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Report').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(doc['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email: ${doc['email']}", style: const TextStyle(color: Colors.blueGrey)),
                      Text("Message: ${doc['message']}"),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteReport(doc.id),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
