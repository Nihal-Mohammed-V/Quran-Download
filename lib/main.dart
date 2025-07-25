// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quran_download/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('downloads');
  await Hive.openBox('bookmarks');
  await FlutterDownloader.initialize(
    debug: true, // set to false in production
    ignoreSsl: true,
  );
  runApp(const QuranMishariApp());
}

class QuranMishariApp extends StatelessWidget {
  const QuranMishariApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quran Mishari Recitations',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}
