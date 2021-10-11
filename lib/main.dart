import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart';

void main(List<String> args) async {
  final parser = ArgParser();
  parser.addFlag('original_file_name');
  parser.addFlag('file_path');
  parser.addFlag('export_path');
  final results = parser.parse(args);
  final originalFileName = results.rest[0];
  final filePath = Directory(results.rest[1]);
  final exportPath = Directory(results.rest[2]);
  await copyDirectory(filePath, exportPath);
  if (Platform.isWindows) {
    Process.run(join(exportPath.absolute.path, originalFileName), []);
  } else if (Platform.isLinux) {
    Process.run(join(exportPath.absolute.path, originalFileName), []);
  }
}

Future<void> copyDirectory(Directory source, Directory destination) async {
  await source.list(recursive: false).forEach((entity) {
    if (entity is Directory) {
      var newDirectory =
          Directory(join(destination.absolute.path, basename(entity.path)));
      newDirectory.createSync(recursive: true);
      copyDirectory(entity.absolute, newDirectory);
    } else if (entity is File) {
      entity.copySync(join(destination.path, basename(entity.path)));
    }
  });
}
