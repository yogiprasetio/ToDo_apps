import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todoapps/ui/login_page.dart';

class DoneToDoPage extends StatelessWidget {
  static const routeName = '/done_page';
  final _firestore = FirebaseFirestore.instance;
  DoneToDoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Done To Doo'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop(MaterialPageRoute(
                builder: (context) {
                  return LoginPage();
                },
              ));
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Log Out',
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _firestore
                  .collection('todo')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                  reverse: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  children: snapshot.data!.docs.map((document) {
                    final data = document.data();
                    return Text(data['id'].toString());
                    // const ListTile(
                    //   leading: Text(data['id'].toString()),
                    //   title: data['title'],
                    //   subtitle: data['detail'],
                    // );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
