// screens/bookmarks_screen.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('bookmarks').listenable(),
      builder: (context, box, widget) {
        final bookmarks = box.values.toList();

        if (bookmarks.isEmpty) {
          return const Center(child: Text('No bookmarks yet.'));
        }

        return ListView.builder(
          itemCount: bookmarks.length,
          itemBuilder: (context, index) {
            final bookmark = bookmarks[index] as Map;
            return ListTile(
              title: Text(bookmark['name']),
              subtitle: Text(
                'Surah ${bookmark['surah']}, Verse ${bookmark['verse']}',
              ),
            );
          },
        );
      },
    );
  }
}
