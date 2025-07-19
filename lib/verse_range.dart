// screens/verse_range_screen.dart
import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;

import 'package:quran_download/download_service.dart';

class VerseRangeScreen extends StatefulWidget {
  final int surahNumber;

  const VerseRangeScreen({super.key, required this.surahNumber});

  @override
  State<VerseRangeScreen> createState() => _VerseRangeScreenState();
}

class _VerseRangeScreenState extends State<VerseRangeScreen> {
  int _startVerse = 1;
  int _endVerse = 1;
  bool _isDownloading = false;
  int _downloadedCount = 0;
  @override
  void initState() {
    super.initState();
    _endVerse = quran.getVerseCount(widget.surahNumber);
  }

  @override
  Widget build(BuildContext context) {
    final verseCount = quran.getVerseCount(widget.surahNumber);

    return Scaffold(
      appBar: AppBar(title: Text(quran.getSurahName(widget.surahNumber))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Select Verse Range (1-$verseCount)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            RangeSlider(
              values: RangeValues(_startVerse.toDouble(), _endVerse.toDouble()),
              min: 1,
              max: verseCount.toDouble(),
              divisions: verseCount - 1,
              labels: RangeLabels(_startVerse.toString(), _endVerse.toString()),
              onChanged: (values) {
                setState(() {
                  _startVerse = values.start.round();
                  _endVerse = values.end.round();
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Start Verse: $_startVerse'),
                Text('End Verse: $_endVerse'),
              ],
            ),
            const Spacer(),

            ElevatedButton.icon(
              icon:
                  _isDownloading
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Icon(Icons.download),
              label: Text(
                _isDownloading
                    ? 'Downloading ($_downloadedCount/${_endVerse - _startVerse + 1})'
                    : 'Download Recitation',
              ),
              onPressed:
                  _isDownloading
                      ? null
                      : () async {
                        setState(() {
                          _isDownloading = true;
                          _downloadedCount = 0;
                        });

                        final total = _endVerse - _startVerse + 1;
                        for (
                          int verse = _startVerse;
                          verse <= _endVerse;
                          verse++
                        ) {
                          await DownloadService.downloadSingleVerse(
                            widget.surahNumber,
                            verse,
                          );
                          setState(() {
                            _downloadedCount++;
                          });
                        }

                        setState(() => _isDownloading = false);

                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'All verses downloaded successfully!',
                            ),
                          ),
                        );
                      },
            ),
          ],
        ),
      ),
    );
  }
}
