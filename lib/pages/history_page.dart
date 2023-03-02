import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../models/history_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/rest_api_service.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  final historyItems = [];

  final service = HttpRestApiService(Dio());

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
        child: FutureBuilder(
          future: service.getHistory(),
          builder: (context,
              AsyncSnapshot<Either<String, List<HistoryItem>>>
                  snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return snapshot.data!.fold(
                    (l) {
                      return Center(
                        child: Text(l),
                      );
                    },
                    (r) {
                      return ListView(
                        children: [
                          for (var item in r)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text('${item.text} ... '),
                                subtitle: Text(item.keywords.toString()),
                              ),
                            ),
                        ],
                      );
                    },
                  );
                }
              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
      ),
    );
  }
}
