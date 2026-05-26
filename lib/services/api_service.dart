import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game_model.dart'; // Cập nhật import

class ApiService {
  static const String _baseUrl = 'https://api.rawg.io/api';
  static const String _apiKey = '5b29bc55c94d4c07acf2dd951c184e2f';

  // Lấy danh sách game phổ biến
  Future<Game?> getTrendingGame() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/games?key=$_apiKey&ordering=-rating&page_size=1'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          return Game.fromJson(data['results'][0]);
        }
      }
      return null;
    } catch (e) {
      print("Lỗi tải trending game: $e");
      return null;
    }
  }

  Future<String> getGameDescription(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/games/$id?key=$_apiKey'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // RAWG trả về 'description_raw' là văn bản thuần không dính thẻ HTML
        return data['description_raw'] ??
            data['description'] ??
            'Không có mô tả cho tựa game này.';
      }
      return 'Lỗi khi tải dữ liệu từ hệ thống.';
    } catch (e) {
      print("Lỗi lấy chi tiết game: $e");
      return 'Không thể kết nối để lấy mô tả game.';
    }
  }

  // Tìm kiếm game theo tên
  Future<List<Game>> searchGames(String query) async {
    try {
      // RAWG hỗ trợ param search trực tiếp
      final response = await http.get(
        Uri.parse('$_baseUrl/games?key=$_apiKey&search=$query'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null) {
          return (data['results'] as List)
              .map((game) => Game.fromJson(game))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print("Lỗi tìm kiếm game: $e");
      return [];
    }
  }

  // 3. Lọc game theo thể loại (Genres) 'action', 'rpg', 'shooter', 'sports'...
  Future<List<Game>> getGamesByGenre(String genreSlug) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/games?key=$_apiKey&genres=$genreSlug'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null) {
          return (data['results'] as List)
              .map((game) => Game.fromJson(game))
              .toList();
        }
        return [];
      } else {
        throw Exception('Lỗi khi tải dữ liệu theo thể loại');
      }
    } catch (e) {
      print("Lỗi lọc thể loại: $e");
      return [];
    }
  }
}
