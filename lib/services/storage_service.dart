import 'package:hive/hive.dart';

import '../features/user_detail/model/post_model.dart';

class StorageService {
  static const String bookmarksBox = 'bookmarks';
  static late Box<Map> _bookmarksBox;

  static Future<void> init() async {
    _bookmarksBox = await Hive.openBox<Map>(bookmarksBox);
  }

  static Future<void> saveBookmark(Post post) async {
    await _bookmarksBox.put(post.id.toString(), post.toJson());
  }

  static Future<void> removeBookmark(int postId) async {
    await _bookmarksBox.delete(postId.toString());
  }

  static List<Post> getBookmarks() {
    return _bookmarksBox.values
        .map((map) => Post.fromJson(Map<String, dynamic>.from(map)))
        .toList();
  }

  static bool isBookmarked(int postId) {
    return _bookmarksBox.containsKey(postId.toString());
  }
}
