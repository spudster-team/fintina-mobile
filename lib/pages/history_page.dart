import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final historyItems = [
    {'title': 'Blkjljl', 'date': DateTime.now().toIso8601String()},
    {'title': 'Blkjljl', 'date': DateTime.now().toIso8601String()},
    {'title': 'Blkjljl', 'date': DateTime.now().toIso8601String()},
    {'title': 'Blkjljl', 'date': DateTime.now().toIso8601String()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Historique'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Rechercher',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            for (var item in historyItems)
              ListTile(
                title: Text(item['title']!),
                subtitle: Text(item['date']!),
              ),
          ],
        ),
      ),
    );
  }
}
