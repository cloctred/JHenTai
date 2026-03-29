import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';

Future<bool> extractZipArchive(String archivePath, String extractPath) {
  return compute(
    (List<String> path) async {
      try {
        final bytes = File(path[0]).readAsBytesSync();
        await extractArchiveToDisk(ZipDecoder().decodeBytes(bytes), path[1]);
      } on Exception catch (_) {
        return false;
      }
      return true;
    },
    [archivePath, extractPath],
  );
}

Future<List<int>> extractGZipArchive(String archivePath) {
  return compute(
    (String path) async {
      try {
        final bytes = File(path).readAsBytesSync();
        return GZipDecoder().decodeBytes(bytes);
      } on Exception catch (_) {
        return [];
      }
    },
    archivePath,
  );
}
