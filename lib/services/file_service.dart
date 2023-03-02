import 'dart:io';

import 'package:pdf_text/pdf_text.dart';

class FileService {
  Future<String> getTextFrom(File file) async {
    try {
      if (file.path.endsWith('.pdf')) {
        PDFDoc pdf = await PDFDoc.fromFile(file);
        return await pdf.text;
      } else if (file.path.endsWith('.txt')) {
        return await file.readAsString();
      }

      return 'Veuillez choisir un fichier `.pdf` ou `.txt`';
    } catch (e) {
      return e.toString();
    }
  }
}
