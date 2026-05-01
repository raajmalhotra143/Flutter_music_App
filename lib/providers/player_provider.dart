import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../data/models/models.dart';
import '../data/services/yt_music_service.dart';

/// PlayerProvider manages global audio playback state using just_audio and YT streaming
class PlayerProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  final YouTubeMusicService _ytService = YouTubeMusicService();

  SongModel? _currentSong;
  bool _isPlaying = false;
  bool _isShuffle = false;
  bool _isRepeat = false;
  double _progress = 0.0;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  PlayerProvider() {
    _player.positionStream.listen((pos) {
      _currentPosition = pos;
      if (_totalDuration.inMilliseconds > 0) {
        _progress = pos.inMilliseconds / _totalDuration.inMilliseconds;
      }
      notifyListeners();
    });

    _player.durationStream.listen((dur) {
      if (dur != null) {
        _totalDuration = dur;
        notifyListeners();
      }
    });

    _player.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });
  }

  SongModel? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  bool get isShuffle => _isShuffle;
  bool get isRepeat => _isRepeat;
  double get progress => _progress;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  bool get hasSong => _currentSong != null;

  Future<void> playSong(SongModel song) async {
    _currentSong = song;
    notifyListeners();

    try {
      final streamUrl = await _ytService.getAudioStreamUrl(song.id);
      if (streamUrl != null) {
        await _player.setUrl(streamUrl);
        await _player.play();
      }
    } catch (e) {
      print('Error playing song: $e');
    }
  }

  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    _player.setShuffleModeEnabled(_isShuffle);
    notifyListeners();
  }

  void toggleRepeat() {
    _isRepeat = !_isRepeat;
    _player.setLoopMode(_isRepeat ? LoopMode.one : LoopMode.off);
    notifyListeners();
  }

  Future<void> seekTo(double value) async {
    final target = Duration(
      milliseconds: (_totalDuration.inMilliseconds * value).round(),
    );
    await _player.seek(target);
  }

  Future<void> setDemoSong() async {
    await playSong(AppData.currentlyPlayingSong);
  }

  String formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _player.dispose();
    _ytService.dispose();
    super.dispose();
  }
}

