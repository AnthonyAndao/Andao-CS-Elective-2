import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Manages Supabase Authentication state and operations.
///
/// Features:
/// • Tracks current [User] and [Session] via [onAuthStateChange].
/// • Email/Password login and sign-up.
/// • 3rd-party OAuth login (GitHub, Google, etc.).
/// • Sign out and error handling.
class AuthController extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;
  late final StreamSubscription<AuthState> _authSubscription;

  User? _user;
  Session? _session;
  bool _isLoading = false;
  String? _errorMessage;

  AuthController() {
    _user = _client.auth.currentUser;
    _session = _client.auth.currentSession;

    // Listen to real-time auth events (e.g. OAuth redirects, sign-in, sign-out)
    _authSubscription = _client.auth.onAuthStateChange.listen((data) {
      _session = data.session;
      _user = data.session?.user;
      notifyListeners();
    });
  }

  User? get user => _user;
  Session? get session => _session;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// User's display name extracted from OAuth metadata or email prefix.
  String get displayName {
    if (_user == null) return '';
    final meta = _user!.userMetadata;
    if (meta != null) {
      if (meta['full_name'] != null && (meta['full_name'] as String).isNotEmpty) {
        return meta['full_name'] as String;
      }
      if (meta['user_name'] != null && (meta['user_name'] as String).isNotEmpty) {
        return meta['user_name'] as String;
      }
      if (meta['name'] != null && (meta['name'] as String).isNotEmpty) {
        return meta['name'] as String;
      }
    }
    return _user!.email?.split('@').first ?? 'User';
  }

  /// Profile picture URL if provided by OAuth provider (e.g. GitHub/Google).
  String? get avatarUrl {
    if (_user == null) return null;
    final meta = _user!.userMetadata;
    if (meta != null) {
      if (meta['avatar_url'] != null) return meta['avatar_url'] as String;
      if (meta['picture'] != null) return meta['picture'] as String;
    }
    return null;
  }

  /// The provider used to log in (e.g. 'github', 'google', 'email').
  String get providerName {
    if (_user == null) return '';
    final appMeta = _user!.appMetadata;
    if (appMeta.containsKey('provider')) {
      final p = appMeta['provider'] as String;
      return p[0].toUpperCase() + p.substring(1);
    }
    return 'Email';
  }

  /// Signs in with Email and Password.
  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      _user = res.user;
      _session = res.session;
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Registers a new user with Email and Password.
  Future<bool> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await _client.auth.signUp(
        email: email.trim(),
        password: password,
      );
      _user = res.user;
      _session = res.session;
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Initiates 3rd-party OAuth login (e.g. [OAuthProvider.github] or [OAuthProvider.google]).
  Future<bool> signInWithOAuth(OAuthProvider provider) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await _client.auth.signInWithOAuth(
        provider,
        redirectTo: kIsWeb ? null : 'io.supabase.solemate://login-callback/',
      );
      return res;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Failed to initiate OAuth login: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _client.auth.signOut();
      _user = null;
      _session = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}

