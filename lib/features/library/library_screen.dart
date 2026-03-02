import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/mini_player.dart';
import '../../data/models/models.dart';
import '../../providers/player_provider.dart';
import '../player/player_screen.dart';

/// My Music / Library screen — My_Music_Library_Screen_3.png
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = [
    'All',
    'Playlists',
    'Liked Songs',
    'Downloads',
  ];

  final List<Color> _coverColors = [
    const Color(0xFFD4A080),
    const Color(0xFF406080),
    const Color(0xFF608060),
    const Color(0xFF804060),
    const Color(0xFF305060),
    const Color(0xFF806040),
  ];

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: GradientBackground(
        colors: const [
          Color(0xFF0F0C20),
          Color(0xFF151230),
          Color(0xFF1A1840),
        ],
        child: Column(
          children: [
            _buildTopBar(),
            const SizedBox(height: 8),
            _buildFilters(),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 200),
                itemCount: AppData.topDailyPlaylists.length,
                itemBuilder: (context, index) => _buildPlaylistItem(
                  AppData.topDailyPlaylists[index],
                  index,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (player.hasSong) const MiniPlayer(),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const Text(
              'My Music',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(
                  Icons.more_horiz_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) => CategoryChip(
          label: _filters[index],
          isSelected: _selectedFilter == index,
          onTap: () => setState(() => _selectedFilter = index),
        ),
      ),
    );
  }

  Widget _buildPlaylistItem(PlaylistModel playlist, int index) {
    return GestureDetector(
      onTap: () {
        context.read<PlayerProvider>().setDemoSong();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PlayerScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: _coverColors[index % _coverColors.length],
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                playlist.coverArt,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.album,
                  color: Colors.white60,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playlist.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'By ${playlist.creator} · ${playlist.songCount} Songs',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white10,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24),
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          color: AppColors.navBarBg,
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavIcon(icon: Icons.home_rounded, active: false),
              _NavIcon(icon: Icons.search_rounded, active: false),
              _NavIcon(icon: Icons.library_music_rounded, active: true),
              _NavIcon(icon: Icons.settings_rounded, active: false),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool active;

  const _NavIcon({required this.icon, required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active
            ? AppColors.limeGreen.withValues(alpha: 0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: active ? AppColors.limeGreen : Colors.white54,
        size: 26,
      ),
    );
  }
}
