import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../services/api_service.dart';

class ExploreProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Game> gridGames = [];
  Game? featuredGame;
  bool isLoading = false;

  String selectedGenre = 'all';
  String lastSearchQuery = '';
  List<Game> myGames = [];

  Future<void> fetchMyGames() async {
    print("Fetch My Games - Firebase đang tắt");
  }

  Future<void> addPersonalGame(Game game) async {
    print("Add Personal Game - Firebase đang tắt");
  }

  Future<void> loadHomeData() async {
    isLoading = true;
    selectedGenre = 'all';
    lastSearchQuery = '';
    notifyListeners();
    try {
      gridGames = await _apiService.searchGames('');
      gridGames.shuffle();
      featuredGame = await _apiService.getTrendingGame();
    } catch (e) {
      print("Error loading home data: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> search(String query) async {
    lastSearchQuery = query;
    isLoading = true;
    notifyListeners();

    try {
      if (selectedGenre == 'all') {
        gridGames = await _apiService.searchGames(query);
      } else {
        List<Game> genreGames = await _apiService.getGamesByGenre(selectedGenre);
        gridGames = genreGames
            .where((g) => g.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    } catch (e) {
      print("Error searching: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> filterByGenre(String genreSlug) async {
    selectedGenre = genreSlug;
    isLoading = true;
    notifyListeners();

    try {
      if (genreSlug == 'all') {
        gridGames = await _apiService.searchGames(lastSearchQuery);
      } else {
        List<Game> genreGames = await _apiService.getGamesByGenre(genreSlug);
        gridGames = genreGames
            .where(
              (g) => g.name.toLowerCase().contains(lastSearchQuery.toLowerCase()),
            )
            .toList();
      }
    } catch (e) {
      print("Lỗi lọc thể loại: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearData() {
    gridGames = [];
    myGames = [];
    notifyListeners();
  }
}