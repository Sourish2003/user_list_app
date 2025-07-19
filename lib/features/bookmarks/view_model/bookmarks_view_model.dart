import 'package:flutter/material.dart';

import '../../../services/storage_service.dart';
import '../../user_list/model/post_model.dart';

class BookmarksViewModel extends ChangeNotifier {
  List<Post> _bookmarks = [];

  List<Post> get bookmarks => _bookmarks;

  void loadBookmarks() {
    _bookmarks = StorageService.getBookmarks();
    notifyListeners();
  }

  Future<void> removeBookmark(int postId) async {
    await StorageService.removeBookmark(postId);
    loadBookmarks();
  }

  void clearAllBookmarks() async {
    for (final post in _bookmarks) {
      await StorageService.removeBookmark(post.id);
    }
    loadBookmarks();
  }
}
