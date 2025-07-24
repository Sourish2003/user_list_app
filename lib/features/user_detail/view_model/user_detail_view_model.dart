import 'package:flutter/material.dart';

import '../../../constants/api_constants.dart';
import '../../../services/api_service.dart';
import '../../../services/storage_service.dart';
import '../model/post_model.dart';
import '../../user_list/model/user_model.dart';

enum UserDetailState { initial, loading, loaded, error }

class UserDetailViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  User? _user;
  List<Post> _posts = [];
  UserDetailState _state = UserDetailState.initial;
  String? _errorMessage;

  User? get user => _user;

  List<Post> get posts => _posts;

  UserDetailState get state => _state;

  String? get errorMessage => _errorMessage;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  Future<void> loadUserPosts(int userId) async {
    _state = UserDetailState.loading;
    notifyListeners();

    try {
      _posts = await _apiService.get<List<Post>>(
        ApiConstants.userPosts(userId),
        (json) => (json as List).map((e) => Post.fromJson(e)).toList(),
      );
      _state = UserDetailState.loaded;
    } catch (e) {
      _state = UserDetailState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  bool isPostBookmarked(int postId) {
    return StorageService.isBookmarked(postId);
  }

  Future<void> toggleBookmark(Post post) async {
    if (isPostBookmarked(post.id)) {
      await StorageService.removeBookmark(post.id);
    } else {
      await StorageService.saveBookmark(post);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}
