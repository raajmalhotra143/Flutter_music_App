import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/mini_player.dart';
import '../../data/models/models.dart';
import '../../providers/player_provider.dart';
import '../library/library_screen.dart';
import 'dart:ui';

/// Main home / browse screen — Music_Discovery_Home_Screen_1.png
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;
  int _currentCarouselPage = 0;
  int _selectedNavIndex = 0;

  final List<String> _categories = ['All', 'New Release', 'Trending', 'Top'];
  final PageController _carouselController = PageController();

  @override
  void dispose() {
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: GradientBackground(
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildTopBar()),
              SliverToBoxAdapter(child: _buildCategories()),
              SliverToBoxAdapter(child: _buildDiscoverCarousel()),
              SliverToBoxAdapter(child: _buildPlaylistsHeader()),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildPlaylistItem(
                      AppData.topDailyPlaylists[index], index),
                  childCount: 3,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 180)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(player),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.glassBorder, width: 2),
            ),
            child: ClipOval(
              child: Image.network(
                'https://picsum.photos/seed/samantha/100/100',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.cardMid,
                  child: const Icon(Icons.person, color: Colors.white70),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, Samantha',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                'Good evening',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_rounded, color: Colors.white),
            iconSize: 26,
          ),
          IconButton(
            onPressed: () {},
            icon:
                const Icon(Icons.favorite_border_rounded, color: Colors.white),
            iconSize: 26,
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) => CategoryChip(
          label: _categories[index],
          isSelected: _selectedCategory == index,
          onTap: () => setState(() => _selectedCategory = index),
        ),
      ),
    );
  }

  Widget _buildDiscoverCarousel() {
    final carouselItems = [
      {
        'title': 'Discover Weekly',
        'subtitle': 'Curated & trending',
        'desc': 'The original slow instrumental\nbest playlists.',
        'imageUrl': 'https://picsum.photos/seed/starlitwk/300/300',
      },
      {
        'title': 'Top Charts',
        'subtitle': "What's hot right now",
        'desc': 'The biggest hits from around\nthe world this week.',
        'imageUrl': 'https://picsum.photos/seed/topcharts/300/300',
      },
      {
        'title': 'Chill Vibes',
        'subtitle': 'Relax & unwind',
        'desc': 'Perfect background music\nfor your day.',
        'imageUrl': 'https://picsum.photos/seed/chillvibes/300/300',
      },
    ];

    return Column(
      children: [
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _carouselController,
            itemCount: carouselItems.length,
            onPageChanged: (i) => setState(() => _currentCarouselPage = i),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildDiscoverCard(carouselItems[index]),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            carouselItems.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentCarouselPage == i ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _currentCarouselPage == i
                    ? AppColors.limeGreen
                    : Colors.white30,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDiscoverCard(Map<String, String> item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6B3FA0), Color(0xFF4A2880), Color(0xFF302B63)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B3FA0).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 12,
            top: 12,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  item['imageUrl']!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFF8060B0),
                    child: const Icon(
                      Icons.headphones,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 16,
            top: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item['subtitle']!,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
                const SizedBox(height: 4),
                Text(
                  item['title']!,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item['desc']!,
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Colors.white60, fontSize: 11),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 14,
            left: 14,
            right: 14,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    context.read<PlayerProvider>().setDemoSong();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.limeGreen,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.limeGreen.withValues(alpha: 0.5),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _ActionIcon(icon: Icons.favorite_border_rounded),
                const SizedBox(width: 10),
                _ActionIcon(icon: Icons.download_rounded),
                const SizedBox(width: 10),
                _ActionIcon(icon: Icons.more_horiz_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistsHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Top daily playlists',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'See all',
              style: TextStyle(color: AppColors.limeGreen, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistItem(PlaylistModel playlist, int index) {
    final colors = [
      const Color(0xFFD4A0A0),
      const Color(0xFF607080),
      const Color(0xFF708060),
    ];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LibraryScreen()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: colors[index % colors.length],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  playlist.coverArt,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.music_note,
                    color: Colors.white,
                    size: 28,
                  ),
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
                  ),
                  const SizedBox(height: 3),
                  Text(
                    playlist.creator,
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
                color: AppColors.glassWhite,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.glassBorder),
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

  Widget _buildBottomNav(PlayerProvider player) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (player.hasSong) const MiniPlayer(),
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              color: AppColors.navBarBg,
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.home_rounded,
                    isActive: _selectedNavIndex == 0,
                    onTap: () => setState(() => _selectedNavIndex = 0),
                  ),
                  _NavItem(
                    icon: Icons.search_rounded,
                    isActive: _selectedNavIndex == 1,
                    onTap: () => setState(() => _selectedNavIndex = 1),
                  ),
                  _NavItem(
                    icon: Icons.library_music_rounded,
                    isActive: _selectedNavIndex == 2,
                    onTap: () {
                      setState(() => _selectedNavIndex = 2);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LibraryScreen()),
                      );
                    },
                  ),
                  _NavItem(
                    icon: Icons.settings_rounded,
                    isActive: _selectedNavIndex == 3,
                    onTap: () => setState(() => _selectedNavIndex = 3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.limeGreen.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isActive ? AppColors.limeGreen : Colors.white54,
          size: 26,
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;

  const _ActionIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: const BoxDecoration(
        color: Colors.white10,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white70, size: 16),
    );
  }
}
