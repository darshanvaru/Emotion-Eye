import 'package:emotioneye/utilities/show_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void showHappyMusicPlaylistPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "🎵 Mood Booster: Happy Vibes Playlist",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _playlistItem(
                context: context,
                title: "Feel Good Pop Hits",
                url: "https://open.spotify.com/playlist/37i9dQZF1DX0XUsuxWHRQd",
              ),
              _playlistItem(
                context: context,
                title: "Happy Hits!",
                url: "https://open.spotify.com/playlist/37i9dQZF1DXdPec7aLTmlC",
              ),
              _playlistItem(
                context: context,
                title: "Good Vibes",
                url: "https://open.spotify.com/playlist/37i9dQZF1DX1BzILRveYHb",
              ),
              _playlistItem(
                context: context,
                title: "Mood Booster",
                url: "https://open.spotify.com/playlist/37i9dQZF1DX3rxVfibe1L0",
              ),
              _playlistItem(
                context: context,
                title: "Upbeat & Energetic",
                url: "https://open.spotify.com/playlist/37i9dQZF1DWUa8ZRTMdqZZ",
              ),
              _playlistItem(
                context: context,
                title: "Songs to Sing in the Car",
                url: "https://open.spotify.com/playlist/37i9dQZF1DWWMOmoXKqHTD",
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text("Close", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      );
    },
  );
}

Widget _playlistItem({required BuildContext context, required String title, required String url}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: ListTile(
      leading: Icon(Icons.music_note_rounded, color: Colors.orange),
      title: Text(title),
      trailing: Icon(Icons.open_in_new, color: Colors.grey),
        onTap: () async {
          final uri = Uri.parse(url);

          final canLaunch = await canLaunchUrl(uri);

          if (!context.mounted) return;

          if (canLaunch) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            showSnackBar(context, "Unable to open playlist. Please try again.", isError: true,
            );
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: Colors.orange[50],
    ),
  );
}
