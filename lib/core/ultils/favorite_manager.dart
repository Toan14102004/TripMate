import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages favorite tours state globally
/// Provides persistent storage and real-time updates across the app
class FavoriteManager extends ChangeNotifier {
  static final FavoriteManager _instance = FavoriteManager._internal();
  factory FavoriteManager() => _instance;
  FavoriteManager._internal();

  final Set<int> _favoriteTourIds = {};
  SharedPreferences? _prefs;

  static const String _favoritesKey = 'favorite_tours';

  bool _isInitialized = false;

  /// Initialize favorite manager by loading from local storage
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _prefs = await SharedPreferences.getInstance();
      final storedFavorites = _prefs?.getString(_favoritesKey);
      if (storedFavorites != null && storedFavorites.isNotEmpty) {
        final List<dynamic> favoriteIds = json.decode(storedFavorites);
        _favoriteTourIds.addAll(favoriteIds.map((id) => id as int));
      }
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing FavoriteManager: $e');
      _isInitialized = true; // Mark as initialized even on error
    }
  }

  /// Check if a tour is favorited
  bool isFavorite(int tourId) {
    return _favoriteTourIds.contains(tourId);
  }

  /// Add tour to favorites
  Future<void> addToFavorites(int tourId) async {
    if (_favoriteTourIds.add(tourId)) {
      await _saveToStorage();
      notifyListeners();
    }
  }

  /// Remove tour from favorites
  Future<void> removeFromFavorites(int tourId) async {
    if (_favoriteTourIds.remove(tourId)) {
      await _saveToStorage();
      notifyListeners();
    }
  }

  /// Toggle favorite status for a tour
  Future<void> toggleFavorite(int tourId) async {
    if (isFavorite(tourId)) {
      await removeFromFavorites(tourId);
    } else {
      await addToFavorites(tourId);
    }
  }

  /// Get all favorite tour IDs
  Set<int> get favoriteTourIds => Set.unmodifiable(_favoriteTourIds);

  /// Get favorite count
  int get favoriteCount => _favoriteTourIds.length;

  /// Clear all favorites
  Future<void> clearAllFavorites() async {
    _favoriteTourIds.clear();
    await _prefs?.remove(_favoritesKey);
    notifyListeners();
  }

  /// Save favorites to local storage
  Future<void> _saveToStorage() async {
    try {
      final favoriteIds = _favoriteTourIds.toList();
      final jsonString = json.encode(favoriteIds);
      await _prefs?.setString(_favoritesKey, jsonString);
    } catch (e) {
      debugPrint('Error saving favorites to storage: $e');
    }
  }

  /// Sync with server favorites (call this when getting server data)
  Future<void> syncWithServerFavorites(List<int> serverFavoriteIds) async {
    final serverSet = Set<int>.from(serverFavoriteIds);
    final localSet = Set<int>.from(_favoriteTourIds);

    // Add server favorites that are not in local
    final toAdd = serverSet.difference(localSet);
    _favoriteTourIds.addAll(toAdd);

    // Remove local favorites that are not in server (optional, depending on business logic)
    // final toRemove = localSet.difference(serverSet);
    // _favoriteTourIds.removeAll(toRemove);

    if (toAdd.isNotEmpty) {
      await _saveToStorage();
      notifyListeners();
    }
  }
}
