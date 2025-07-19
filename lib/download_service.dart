// services/download_service.dart

import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:permission_handler/permission_handler.dart';

class DownloadService {
  static const String _baseUrl = 'https://verses.quran.com/Alafasy/mp3/';

  static Future<void> downloadSingleVerse(int surahNumber, int verse) async {
    if (!await _checkPermission()) return;

    final dir = Directory('/storage/emulated/0/Download');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final verseStr = verse.toString().padLeft(3, '0');
    final surahStr = surahNumber.toString().padLeft(3, '0');
    final url = '$_baseUrl${surahStr}${verseStr}.mp3';
    final fileName = 'Mishari_S${surahStr}_V$verseStr.mp3';

    try {
      await FlutterDownloader.enqueue(
        url: url,
        savedDir: dir.path,
        fileName: fileName,
        showNotification: true,
        openFileFromNotification: true,
      );
      print("Download enqueued");
    } catch (e) {
      print("Download failed: $e");
    }
  }

  static Future<bool> _checkPermission() async {
    if (await Permission.storage.isGranted) return true;

    final status = await Permission.manageExternalStorage.request();
    return status.isGranted;
  }
}
