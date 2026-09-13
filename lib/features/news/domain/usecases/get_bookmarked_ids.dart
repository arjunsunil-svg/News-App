import '../repositories/news_repository.dart';

class GetBookmarkedIds {
  const GetBookmarkedIds(this._repository);

  final NewsRepository _repository;

  List<String> call() {
    return _repository.getBookmarkedIds();
  }
}