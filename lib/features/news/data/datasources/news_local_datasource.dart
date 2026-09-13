import '../../../../core/storage/hive_storage.dart';

class NewsLocalDataSource {
  const NewsLocalDataSource(this._storage);

  final HiveStorage _storage;

  Future<void> addBookmark(String articleId) async {
    await _storage.bookmarksBox.put(
      articleId,
      articleId,
    );
  }

  Future<void> removeBookmark(String articleId) async {
    await _storage.bookmarksBox.delete(articleId);
  }

  bool isBookmarked(String articleId) {
    return _storage.bookmarksBox.containsKey(articleId);
  }

  List<String> getBookmarkedIds() {
    return _storage.bookmarksBox.values.toList();
  }

}