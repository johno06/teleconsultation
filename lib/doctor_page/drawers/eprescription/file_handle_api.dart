import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pdfLib;

class FileHandleApi {
  // save pdf file function
  static Future<File> saveDocument({
    required String name,
    required pdfLib.Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  // open pdf file function
  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
