import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final _supabase = Supabase.instance.client;

  Future<void> createUserProfile({
    required String id,
    required String email,
    String? displayName,
    String? avatarUrl,
  }) async {
    await _supabase.from('users').upsert({
      'id': id,
      'email': email,
      'display_name': displayName,
      'avatar_url': avatarUrl,
    });
  }

  Future<Map<String, dynamic>?> getUserProfile(String id) async {
    final response = await _supabase.from('users').select().eq('id', id).maybeSingle();
    return response;
  }

  Future<void> addLikedSong({
    required String userId,
    required String ytVideoId,
    required String title,
    required String artist,
    String? coverUrl,
  }) async {
    await _supabase.from('liked_songs').insert({
      'user_id': userId,
      'yt_video_id': ytVideoId,
      'title': title,
      'artist': artist,
      'cover_url': coverUrl,
    });
  }

  Future<List<Map<String, dynamic>>> getLikedSongs(String userId) async {
    final response = await _supabase.from('liked_songs').select().eq('user_id', userId);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> createPlaylist({
    required String userId,
    required String name,
    String? coverImage,
  }) async {
    await _supabase.from('playlists').insert({
      'user_id': userId,
      'name': name,
      'cover_image': coverImage,
    });
  }

  Future<List<Map<String, dynamic>>> getPlaylists(String userId) async {
    final response = await _supabase.from('playlists').select().eq('user_id', userId);
    return List<Map<String, dynamic>>.from(response);
  }
}
