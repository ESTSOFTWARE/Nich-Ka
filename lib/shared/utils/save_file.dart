import 'dart:io';

Future<void> saveFile(List<int> bytes, String fileName, String mimeType) async {
  final dir = Directory.systemTemp;
  final file = File('${dir.path}/$fileName');
  await file.writeAsBytes(bytes);
}
