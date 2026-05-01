# SoundWave Music - Project Blueprint

## Overview
SoundWave Music is a high-fidelity music streaming application built with Flutter. It features a modern "Glassmorphism" UI, interactive components, and a hybrid backend leveraging Firebase for Authentication and Supabase for the relational database. It integrates with YouTube Music to provide real-time song synchronization and playback.

## Project Details & Features
*   **Style & Design:**
    *   Dark Theme with deep blue/purple gradients (`#0F0C29` to `#24243E`).
    *   Lime Green accent color (`#D4FF2A`).
    *   Glassmorphism effects for cards, navigation bars, and overlays.
    *   Interactive carousels and smooth transitions.
*   **Authentication:** Firebase Authentication (Phase 1 Migration).
*   **Database:** Supabase (PostgreSQL) for user profiles, playlists, and favorites.
*   **Music Integration:** 
    *   YouTube Music API (via `youtube_explode_dart`) for metadata and streaming.
    *   Automated synchronization of new releases.
*   **Playback:** `just_audio` and `audio_service` for background playback and lock screen controls.

## Implementation Plan - Hybrid Backend & YouTube Music Sync

### Phase 1: Authentication Migration (Firebase) [DONE]
1.  **Add Dependencies:** Added `firebase_auth`.
2.  **Firebase Initialization:** Added to `main.dart`.
3.  **Auth Provider Refactor:** Created `lib/providers/auth_provider.dart` using `FirebaseAuth`.
4.  **UI Updates:** `AuthScreen` and `HomeScreen` connected to `AuthProvider`.

### Phase 2: Database Setup (Supabase) [DONE]
1.  **Schema Definition:** SQL schema provided (implicit in `DatabaseService`).
2.  **Sync Logic:** `AuthProvider` now calls `DatabaseService.createUserProfile` on auth changes.
3.  **Database Service:** Implemented `lib/data/services/database_service.dart`.

### Phase 3: YouTube Music Integration [DONE]
1.  **YouTube Service:** Implemented `lib/data/services/yt_music_service.dart` for fetching releases and stream URLs.
2.  **Playback Logic:** `PlayerProvider` refactored to use `just_audio` and stream from YouTube.
3.  **Live Data Binding:** Home Screen carousel now displays real YouTube new releases.

---
*Last updated: 2026-05-01*
