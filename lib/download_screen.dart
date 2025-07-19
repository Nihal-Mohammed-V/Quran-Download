// screens/download_screen.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentlyPlaying;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('downloads').listenable(),
      builder: (context, box, widget) {
        final downloads = box.values.toList();

        if (downloads.isEmpty) {
          return const Center(child: Text('No downloads yet.'));
        }

        return ListView.builder(
          itemCount: downloads.length,
          itemBuilder: (context, index) {
            final download = downloads[index] as Map;
            final isPlaying = _currentlyPlaying == download['path'];

            return ListTile(
              title: Text(download['name']),
              subtitle: Text(
                'Surah ${download['surah']}, Verse ${download['verse']}',
              ),
              trailing:
                  isPlaying
                      ? const Icon(Icons.volume_up)
                      : IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed:
                            () =>
                                _playAudio(download['path'], download['name']),
                      ),
            );
          },
        );
      },
    );
  }

  Future<void> _playAudio(String path, String name) async {
    try {
      setState(() => _currentlyPlaying = path);
      await _audioPlayer.setFilePath(path);
      await _audioPlayer.play();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error playing audio: $e')));
      setState(() => _currentlyPlaying = null);
    }
  }
}
