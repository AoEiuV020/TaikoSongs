import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';

class DocumentSaver {
  static Future<bool> save(
      Uint8List data, String filename, String ext, String mimetype) async {
    try {
      var saveAsResult = await FileSaver.instance.saveAs(
        name: filename,
        bytes: data,
        ext: ext,
        mimeType: MimeType.custom,
        customMimeType: mimetype,
      );
      return saveAsResult != null && saveAsResult.isNotEmpty;
    } catch (e) {
      debugPrint(e.toString());
    }
    try {
      var saveResult = await FileSaver.instance.saveFile(
        name: filename,
        bytes: data,
        ext: '.$ext',
        mimeType: MimeType.custom,
        customMimeType: mimetype,
      );
      return saveResult.isNotEmpty;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
