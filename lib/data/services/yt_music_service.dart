import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../../data/models/models.dart';

class YouTubeMusicService {
  final _yt = YoutubeExplode();

  Future<List<SongModel>> getNewReleases() async {
    try {
      // Search for music videos with "New Releases" context or specific music channels
      // Alternatively, we can use a known YouTube Music playlist ID for new releases
      // For this example, we'll search for trending music
      final searchResult = await _yt.search.search(
        'new music releases 2026',
        filter: TypeFilters.video,
      );

      final songs = <SongModel>[];
      for (final video in searchResult.take(10)) {
        final duration = video.duration ?? Duration.zero;
        final minutes = duration.inMinutes;
        final seconds = duration.inSeconds % 60;
        final durationString = '$minutes:${seconds.toString().padLeft(2, '0')}';

        songs.add(SongModel(
          id: video.id.value,
          title: video.title,
          artist: video.author,
          albumArt: video.thumbnails.highResUrl,
          duration: durationString,
        ));
      }
      return songs;
    } catch (e) {
      print('Error fetching new releases: $e');
      return [];
    }
  }

  Future<String?> getAudioStreamUrl(String videoId) async {
    try {
      final manifest = await _yt.videos.streamsClient.getManifest(videoId);
      final audioStream = manifest.audioOnly.withHighestBitrate();
      return audioStream.url.toString();
    } catch (e) {
      print('Error getting stream URL: $e');
      return null;
    }
  }

  void dispose() {
    _yt.close();
  }
}
