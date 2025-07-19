// services/download_service.dart

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadService {
  static const String _baseUrl =
      'https://verses.quran.com/mishari_alafasy_audio/';

  static Future<void> downloadMishariRecitation(
    int surahNumber,
    int startVerse,
    int endVerse,
  ) async {
    // Check and request storage permission
    if (!await _checkPermission()) return;

    // Get download directory
    final dir = await getExternalStorageDirectory();
    if (dir == null) return;

    // Download each verse in the range
    for (int verse = startVerse; verse <= endVerse; verse++) {
      final verseStr = verse.toString().padLeft(3, '0');
      final surahStr = surahNumber.toString().padLeft(3, '0');
      final url = '$_baseUrl$surahStr/$surahStr$verseStr.mp3';
      final fileName = 'Mishari_S${surahStr}_V$verseStr.mp3';

      await FlutterDownloader.enqueue(
        url: url,
        savedDir: dir.path,
        fileName: fileName,
        showNotification: true,
        openFileFromNotification: true,
      );
    }
  }

  static Future<bool> _checkPermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }
}
