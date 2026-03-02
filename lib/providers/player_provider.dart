import 'package:flutter/material.dart';
import '../../data/models/models.dart';

/// PlayerProvider manages global audio playback state
class PlayerProvider extends ChangeNotifier {
  SongModel? _currentSong;
  bool _isPlaying = false;
  bool _isShuffle = false;
  bool _isRepeat = false;
  double _progress = 0.28 / 2.43; // 0:28 of 2:43 for demo
  Duration _currentPosition = const Duration(seconds: 28);
  Duration _totalDuration = const Duration(minutes: 2, seconds: 43);

  SongModel? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  bool get isShuffle => _isShuffle;
  bool get isRepeat => _isRepeat;
  double get progress => _progress;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  bool get hasSong => _currentSong != null;

  void playSong(SongModel song) {
    _currentSong = song;
    _isPlaying = true;
    _progress = 0.0;
    _currentPosition = Duration.zero;
    notifyListeners();
  }

  void togglePlayPause() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  void toggleRepeat() {
    _isRepeat = !_isRepeat;
    notifyListeners();
  }

  void seekTo(double value) {
    _progress = value.clamp(0.0, 1.0);
    _currentPosition = Duration(
      milliseconds: (_totalDuration.inMilliseconds * _progress).round(),
    );
    notifyListeners();
  }

  void setDemoSong() {
    _currentSong = AppData.currentlyPlayingSong;
    _isPlaying = true;
    _progress = 0.28 / 2.43;
    _currentPosition = const Duration(seconds: 28);
    _totalDuration = const Duration(minutes: 2, seconds: 43);
    notifyListeners();
  }

  String formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

/// AuthProvider manages authentication state
class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _userName = 'Samantha';
  final String _userAvatar = 'https://picsum.photos/seed/samantha/100/100';

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get userAvatar => _userAvatar;

  void login(String email, String password) {
    // Demo login
    _isLoggedIn = true;
    _userName = 'Samantha';
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
