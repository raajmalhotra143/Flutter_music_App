import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/services/database_service.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  final DatabaseService _dbService = DatabaseService();

  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  String get userName => _user?.displayName ?? _user?.email?.split('@').first ?? 'User';
  String get userAvatar => _user?.photoURL ?? 'https://picsum.photos/seed/samantha/100/100';

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) async {
      _user = user;
      if (user != null) {
        try {
          // Sync profile on every login to ensure it exists in Supabase
          await _dbService.createUserProfile(
            id: user.uid,
            email: user.email ?? '',
            displayName: user.displayName,
            avatarUrl: user.photoURL,
          );
        } catch (e) {
          debugPrint('Supabase profile sync failed: $e');
          // We don't want to block login if Supabase sync fails
          // This allows the user to still use the app if Supabase is misconfigured
        }
      }
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    // Google Sign-in implementation disabled due to package conflicts
  }

  Future<void> logout() async {
    await _auth.signOut();
    // await _googleSignIn.signOut();
  }
}

