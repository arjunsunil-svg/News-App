import '../repositories/news_repository.dart';

class RemoveBookmark {
  const RemoveBookmark(this._repository);

  final NewsRepository _repository;

  Future<void> call(String articleId) {
    return _repository.removeBookmark(articleId);
  }
}