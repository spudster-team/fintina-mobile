import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fintina/services/file_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../constants.dart';
import '../services/rest_api_service.dart';
import '../widgets/left_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? filename;

  final textController = TextEditingController();

  String? algo;

  File? file;

  final fileService = FileService();

  final apiService = HttpRestApiService(Dio());

  void _uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
        filename = file!.path.split('/').last;
      });

      final text = await fileService.getTextFrom(file!);

      setState(() {
        textController.text = text;
      });
    }
  }

  void _findKeywords() async {
    final res = await apiService.getKeywords(textController.text);
    res.fold(
      (l) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l),
          ),
        );
      },
      (r) {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return KeywordsContainer(keywords: r);
          },
        );
      },
    );
  }

  void _reset() {
    textController.clear();
    setState(() {
      file = null;
      filename = null;
    });
  }

  final keywords = [
    'joie',
    'euphorie',
    'bonheur',
    'satisfaction',
    'contentement',
    'sérénité',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blue,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Fintina',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            bottom: 20.0,
          ),
          child: Column(
            children: [
              Center(
                child: Container(
                  height: 1.5,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                flex: 5,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextField(
                            maxLines: 20,
                            controller: textController,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: _uploadFile,
                            child: Container(
                              width: 70,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(151, 160, 142, 252),
                              ),
                              child: const Center(
                                child: Text(
                                  'Upload',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(child: Text(filename ?? 'filename')),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: const Color(0xff87bef8),
                                ),
                                onPressed: _findKeywords,
                                child: const Text('Trouver'),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: const Color(0xfff9b07f),
                                ),
                                onPressed: _reset,
                                child: const Text('Réinitialiser'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xffa08efc),
                          ),
                          onPressed: () {},
                          child: DropdownButton<String>(
                            underline: Container(),
                            isExpanded: true,
                            hint: const Text(
                              'Algo',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            value: algo,
                            items: const [
                              DropdownMenuItem(
                                value: 'tf-idf',
                                child: Text('TF-IDF'),
                              ),
                              DropdownMenuItem(
                                value: 'carry',
                                child: Text(
                                  'Carry',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'semantique',
                                child: Text('Sémantique'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                algo = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: const LeftDrawer(),
    );
  }
}

class KeywordsContainer extends StatelessWidget {
  const KeywordsContainer({
    Key? key,
    required this.keywords,
  }) : super(key: key);

  final List<String> keywords;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Mot-clés',
            style: TextStyle(
              color: Color(0xff647ae9),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        Wrap(
          children: keywords.map((e) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(e),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: colors['darkBlue'],
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
