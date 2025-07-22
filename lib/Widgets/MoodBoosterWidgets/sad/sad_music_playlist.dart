import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void showSadPlaylistPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "Recommended Playlist for Sad Mood",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _playlistItem(
                title: "Sad Lo-fi Chill",
                url: "https://open.spotify.com/playlist/37i9dQZF1DX3rxVfibe1L0",
              ),
              _playlistItem(
                title: "Soft Piano Comfort",
                url: "https://open.spotify.com/playlist/37i9dQZF1DX4sWSpwq3LiO",
              ),
              _playlistItem(
                title: "Acoustic Heartbreak",
                url: "https://open.spotify.com/playlist/37i9dQZF1DWXq91oLsHZvy",
              ),
              _playlistItem(
                title: "Emotional Indie Pop",
                url: "https://open.spotify.com/playlist/37i9dQZF1DWZBCPUIUs2iR",
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

Widget _playlistItem({required String title, required String url}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: ListTile(
      leading: Icon(Icons.music_note_rounded, color: Colors.blue),
      title: Text(title),
      trailing: Icon(Icons.open_in_new, color: Colors.grey),
      onTap: () async {
        Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          debugPrint("[sad_music_playlist] Could not launch $url");
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: Colors.grey[100],
    ),
  );
}