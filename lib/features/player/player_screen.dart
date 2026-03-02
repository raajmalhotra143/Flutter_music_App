import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/models.dart';
import '../../providers/player_provider.dart';

/// Full Player Screen — Now_Playing_Screen_2.png
class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with TickerProviderStateMixin {
  late final AnimationController _albumArtController;
  late final Animation<double> _albumArtScale;
  int _activeLyricLine = 0;

  @override
  void initState() {
    super.initState();
    _albumArtController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _albumArtScale = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _albumArtController, curve: Curves.elasticOut),
    );
    _albumArtController.forward();
    _scheduleLyricAdvance();
  }

  void _scheduleLyricAdvance() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        _activeLyricLine = (_activeLyricLine + 1) % AppData.lyrics.length;
      });
      _scheduleLyricAdvance();
    });
  }

  @override
  void dispose() {
    _albumArtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    final song = player.currentSong ?? AppData.discoverWeeklySong;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [
              Color(0xFF3A2060),
              Color(0xFF1A1030),
              Color(0xFF0F0C20),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(song),
              const SizedBox(height: 16),
              _buildAlbumArt(song),
              const SizedBox(height: 20),
              _buildSongInfo(song),
              const SizedBox(height: 16),
              _buildLyrics(),
              const Spacer(),
              _buildProgressBar(player),
              const SizedBox(height: 20),
              _buildControls(player),
              const SizedBox(height: 16),
              _buildBottomRow(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(SongModel song) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white10,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24),
              ),
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => song.isLiked = !song.isLiked),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white10,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24),
              ),
              child: Icon(
                song.isLiked
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: song.isLiked ? AppColors.limeGreen : Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumArt(SongModel song) {
    return ScaleTransition(
      scale: _albumArtScale,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6B3FA0).withValues(alpha: 0.6),
              blurRadius: 40,
              spreadRadius: 10,
            ),
            BoxShadow(
              color: AppColors.limeGreen.withValues(alpha: 0.15),
              blurRadius: 60,
              spreadRadius: 5,
            ),
          ],
        ),
        child: ClipOval(
          child: Image.network(
            song.albumArt,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6B3FA0), Color(0xFF302B63)],
                ),
              ),
              child: const Icon(
                Icons.headphones,
                color: Colors.white,
                size: 80,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSongInfo(SongModel song) {
    return Column(
      children: [
        Text(
          song.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          song.artist,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildLyrics() {
    final displayLines = AppData.lyrics.take(5).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: List.generate(displayLines.length, (i) {
          final isActive = i == _activeLyricLine % 5;
          final lyric = displayLines[i];
          if (lyric.isEmpty) return const SizedBox(height: 6);
          return AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 400),
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white38,
              fontSize: isActive ? 15 : 13,
              fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text(lyric, textAlign: TextAlign.center),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildProgressBar(PlayerProvider player) {
    final remaining = player.totalDuration - player.currentPosition;
    final remainingStr = '-${player.formatDuration(remaining)}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: AppColors.limeGreen,
              inactiveTrackColor: const Color(0x33FFFFFF),
              thumbColor: AppColors.limeGreen,
              overlayColor: AppColors.limeGreen.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: player.progress.clamp(0.0, 1.0),
              onChanged: (value) => player.seekTo(value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  player.formatDuration(player.currentPosition),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                Text(
                  remainingStr,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(PlayerProvider player) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _ControlButton(
            icon: Icons.shuffle_rounded,
            size: 22,
            active: player.isShuffle,
            onTap: player.toggleShuffle,
          ),
          _ControlButton(
            icon: Icons.skip_previous_rounded,
            size: 36,
            onTap: () {},
          ),
          GestureDetector(
            onTap: player.togglePlayPause,
            child: Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: AppColors.limeGreen,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.limeGreen.withValues(alpha: 0.5),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                player.isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                color: Colors.black,
                size: 40,
              ),
            ),
          ),
          _ControlButton(
            icon: Icons.skip_next_rounded,
            size: 36,
            onTap: () {},
          ),
          _ControlButton(
            icon: Icons.repeat_rounded,
            size: 22,
            active: player.isRepeat,
            onTap: player.toggleRepeat,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.queue_music_rounded),
          color: Colors.white54,
          onPressed: () {},
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final bool active;
  final VoidCallback? onTap;

  const _ControlButton({
    required this.icon,
    required this.size,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        color: active ? AppColors.limeGreen : Colors.white,
        size: size,
        shadows: active
            ? [
                Shadow(
                  color: AppColors.limeGreen.withValues(alpha: 0.6),
                  blurRadius: 8,
                ),
              ]
            : null,
      ),
    );
  }
}
