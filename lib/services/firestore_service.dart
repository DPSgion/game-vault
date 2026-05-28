import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/game_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Lưu đánh giá game
  Future<void> savePlayedGame(Game game, int rating, String review) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Chưa xác thực người dùng");

    // Cấu trúc: users/{uid}/played_games/{gameId}
    final docRef = _db
        .collection('users')
        .doc(user.uid)
        .collection('played_games')
        .doc(game.id.toString());

    await docRef.set({
      'gameId': game.id,
      'name': game.name,
      'backgroundImage': game.backgroundImage,
      'rating': rating,
      'review': review,
      'savedAt': FieldValue.serverTimestamp(),
    });
  }

  // Lấy danh sách game đã chơi
  Stream<QuerySnapshot> getPlayedGames() {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Chưa xác thực người dùng");

    return _db
        .collection('users')
        .doc(user.uid)
        .collection('played_games')
        .orderBy('savedAt', descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot> getGameReviewStream(String gameId) {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Chưa xác thực người dùng");

    return _db
        .collection('users')
        .doc(user.uid)
        .collection('played_games')
        .doc(gameId)
        .snapshots();
  }

  // Xóa game khỏi thư viện
  Future<void> deletePlayedGame(String gameId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Chưa xác thực người dùng");

    await _db
        .collection('users')
        .doc(user.uid)
        .collection('played_games')
        .doc(gameId)
        .delete();
  }

  // Cập nhật đánh giá
  Future<void> updatePlayedGameReview(String gameId, int rating, String review) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Chưa xác thực người dùng");

    await _db
        .collection('users')
        .doc(user.uid)
        .collection('played_games')
        .doc(gameId)
        .update({
      'rating': rating,
      'review': review,
      'savedAt': FieldValue.serverTimestamp(),
    });
  }
}