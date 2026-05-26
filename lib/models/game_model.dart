class Game {
  final String id;
  final String name;
  final String backgroundImage;
  final String genres;
  final String platforms;
  final String description;
  final String personalNote;
  final String? userId;

  Game({
    required this.id,
    required this.name,
    required this.backgroundImage,
    required this.genres,
    this.platforms = "",
    this.description = "",
    this.personalNote = "",
    this.userId,
  });

  // 1. Chuyển từ Map (Firebase) sang Object (Flutter)
  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      backgroundImage: map['backgroundImage'] ?? '',
      genres: map['genres'] ?? '',
      platforms: map['platforms'] ?? '',
      description: map['description'] ?? '',
      personalNote: map['personalNote'] ?? '',
      userId: map['userId'],
    );
  }

  // 2. Chuyển từ Object sang Map để lưu lên Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'backgroundImage': backgroundImage,
      'genres': genres,
      'platforms': platforms,
      'description': description,
      'personalNote': personalNote,
      'userId': userId,
    };
  }

  // 3. Parse JSON từ RAWG API
  factory Game.fromJson(Map<String, dynamic> json) {
    // Xử lý mảng genres
    String parsedGenres = '';
    if (json['genres'] != null) {
      parsedGenres = (json['genres'] as List).map((g) => g['name']).join(', ');
    }

    // Xử lý mảng platforms
    String parsedPlatforms = '';
    if (json['platforms'] != null) {
      parsedPlatforms = (json['platforms'] as List)
          .map((p) => p['platform']['name'])
          .join(', ');
    }

    return Game(
      id: json['id'].toString(), // RAWG trả id dạng int, parse sang String cho Firebase
      name: json['name'] ?? '',
      backgroundImage: json['background_image'] ?? '', // Đổi từ thumbnail
      genres: parsedGenres,
      platforms: parsedPlatforms,
      description: json['description_raw'] ?? '', // RAWG thường chỉ trả description_raw ở endpoint detail
      personalNote: '',
      userId: null,
    );
  }
}