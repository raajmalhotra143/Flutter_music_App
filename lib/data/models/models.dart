import 'package:flutter/material.dart';

/// Data models for the music app

class SongModel {
  final String id;
  final String title;
  final String artist;
  final String albumArt; // URL or asset path
  final String duration;
  bool isLiked;

  SongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.albumArt,
    required this.duration,
    this.isLiked = false,
  });
}

class PlaylistModel {
  final String id;
  final String name;
  final String creator;
  final String coverArt;
  final int songCount;
  final List<SongModel> songs;

  const PlaylistModel({
    required this.id,
    required this.name,
    required this.creator,
    required this.coverArt,
    required this.songCount,
    this.songs = const [],
  });
}

/// Sample data matching the UI designs
class AppData {
  static final List<PlaylistModel> topDailyPlaylists = [
    PlaylistModel(
      id: '1',
      name: 'Starlit Reverie',
      creator: 'Budiarti',
      coverArt: 'https://picsum.photos/seed/starlit/200/200',
      songCount: 8,
      songs: _starlitSongs,
    ),
    PlaylistModel(
      id: '2',
      name: 'Midnight Confessions',
      creator: 'Alexiao',
      coverArt: 'https://picsum.photos/seed/midnight/200/200',
      songCount: 24,
      songs: _midnightSongs,
    ),
    PlaylistModel(
      id: '3',
      name: 'Lost in the Echo',
      creator: 'Alexiao',
      coverArt: 'https://picsum.photos/seed/echo/200/200',
      songCount: 24,
      songs: [],
    ),
    PlaylistModel(
      id: '4',
      name: 'Letters I Never Sent',
      creator: 'Alexiao',
      coverArt: 'https://picsum.photos/seed/letters/200/200',
      songCount: 24,
      songs: [],
    ),
    PlaylistModel(
      id: '5',
      name: 'Breaking the Silence',
      creator: 'Alexiao',
      coverArt: 'https://picsum.photos/seed/silence/200/200',
      songCount: 24,
      songs: [],
    ),
    PlaylistModel(
      id: '6',
      name: 'Tears on the Vinyl',
      creator: 'Alexiao',
      coverArt: 'https://picsum.photos/seed/tears/200/200',
      songCount: 24,
      songs: [],
    ),
  ];

  static final List<SongModel> _starlitSongs = [
    SongModel(
      id: 's1',
      title: 'Starlit Reverie',
      artist: 'Budiarti x Lil magrib',
      albumArt: 'https://picsum.photos/seed/starlit/400/400',
      duration: '3:28',
      isLiked: true,
    ),
  ];

  static final List<SongModel> _midnightSongs = [
    SongModel(
      id: 'm1',
      title: 'Midnight Confessions',
      artist: 'Alexiao x Lil magrib',
      albumArt: 'https://picsum.photos/seed/midnight/400/400',
      duration: '2:43',
    ),
  ];

  static SongModel get currentlyPlayingSong => SongModel(
        id: 'm1',
        title: 'Midnight Confessions',
        artist: 'Alexiao x Lil magrib',
        albumArt: 'https://picsum.photos/seed/midnight/400/400',
        duration: '2:43',
      );

  static SongModel get discoverWeeklySong => SongModel(
        id: 's1',
        title: 'Starlit Reverie',
        artist: 'Budiarti x Lil magrib',
        albumArt: 'https://picsum.photos/seed/starlit/400/400',
        duration: '3:28',
      );

  static const List<String> lyrics = [
    'Whispers in the midnight breeze,',
    'Carrying dreams across the seas,',
    'I close my eyes, let go, and drift away.',
    '',
    'Stars that light the darkened sky,',
    'Remind me of the days gone by,',
    'When everything felt so clear, so true.',
    '',
    'In the stillness of the night,',
    'I find myself in fading light,',
    'Chasing shadows, chasing you.',
  ];
}

/// Color palette constants for cover art backgrounds (matching design)
class CoverColors {
  static const Color pink = Color(0xFFE8A0A0);
  static const Color teal = Color(0xFF80C8C8);
  static const Color purple = Color(0xFF9080C8);
  static const Color olive = Color(0xFF808060);
  static const Color coral = Color(0xFFE8A080);
}

/// Playlist cover art colors matching the UI design
final List<Color> playlistColors = [
  const Color(0xFFD4A0A0), // Starlit Reverie - warm pink
  const Color(0xFF607080), // Midnight Confessions - dark teal
  const Color(0xFF708060), // Lost in the Echo - olive
  const Color(0xFF8070A0), // Letters I Never Sent - purple
  const Color(0xFF406070), // Breaking the Silence - dark blue
  const Color(0xFF806050), // Tears on the Vinyl - warm brown
];
