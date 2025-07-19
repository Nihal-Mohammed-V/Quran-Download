// screens/surah_list_screen.dart
import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;

import 'package:quran_download/verse_range.dart';

class SurahListScreen extends StatelessWidget {
  const SurahListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: quran.totalSurahCount,
      itemBuilder: (context, index) {
        int surahNumber = index + 1;
        return ListTile(
          leading: CircleAvatar(child: Text(surahNumber.toString())),
          title: Text(quran.getSurahName(surahNumber)),
          subtitle: Text(
            '${quran.getVerseCount(surahNumber)} verses - ${quran.getSurahNameEnglish(surahNumber)}',
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => VerseRangeScreen(surahNumber: surahNumber),
              ),
            );
          },
        );
      },
    );
  }
}
