
import 'dart:io';

import 'package:flutter_app_boilerplate/common/utils/string_util.dart';
import 'package:path_provider/path_provider.dart';

class FileUtil {
  static String fileName = 'flutter_app_boilerplate.txt';

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> get localFile async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  static Future<String> readFile() async {
    try {
      final file = await localFile;

      // Read the file
      return await file.readAsString();
    } catch (e) {
      // If encountering an error, return 0
      return StringUtil.empty;
    }
  }

  static Future<File> writeFile(String content) async {
    final file = await localFile;

    // Write the file
    return file.writeAsString(content);
  }
}
