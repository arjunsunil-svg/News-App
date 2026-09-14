import 'package:get/get.dart';

import '../../../../core/utils/app_strings.dart';
import '../../domain/entities/article_entity.dart';
import '../../domain/usecases/bookmark_article.dart';
import '../../domain/usecases/get_bookmarked_ids.dart';
import '../../domain/usecases/get_bookmarked_news.dart';
import '../../domain/usecases/get_news.dart';
import '../../domain/usecases/remove_bookmark.dart';

class NewsController extends GetxController {
  NewsController({
    required GetNews getNews,
    required BookmarkArticle bookmarkArticle,
    required RemoveBookmark removeBookmark,
    required GetBookmarkedIds getBookmarkedIds,
    required GetBookmarkedNews getBookmarkedNews,
  })  : _getNews = getNews,
        _bookmarkArticle = bookmarkArticle,
        _removeBookmark = removeBookmark,
        _getBookmarkedIds = getBookmarkedIds,
        _getBookmarkedNews = getBookmarkedNews;

  final GetNews _getNews;
  final BookmarkArticle _bookmarkArticle;
  final RemoveBookmark _removeBookmark;
  final GetBookmarkedIds _getBookmarkedIds;
  final GetBookmarkedNews _getBookmarkedNews;

  final isLoading = false.obs;

  final articles = <ArticleEntity>[].obs;

  final allArticles = <ArticleEntity>[].obs;

  final bookmarkedArticles = <ArticleEntity>[].obs;

  final bookmarkedArticleIds = <String>{}.obs;

  final searchQuery = ''.obs;

  final selectedCategory = AppStrings.allCategoriesLabel.obs;

  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();

    loadBookmarks();
    loadNews();
  }

  List<String> get categories {
    final unique = <String>{};

    for (final article in allArticles) {
      unique.addAll(article.categories);
    }

    final sorted = unique.toList()..sort();

    return [AppStrings.allCategoriesLabel, ...sorted];
  }

  Future<void> loadNews() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final result = await _getNews();

      allArticles.assignAll(result);
      _applyFilters();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void search(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    _applyFilters();
  }

  void _applyFilters() {
    final normalizedQuery = searchQuery.value.trim().toLowerCase();

    final results = allArticles.where((article) {
      final matchesCategory = selectedCategory.value ==
          AppStrings.allCategoriesLabel ||
          article.categories.contains(selectedCategory.value);

      final matchesSearch = normalizedQuery.isEmpty ||
          article.title.toLowerCase().contains(normalizedQuery) ||
          article.description.toLowerCase().contains(normalizedQuery);

      return matchesCategory && matchesSearch;
    }).toList();

    articles.assignAll(results);
  }

  Future<void> toggleBookmark(String articleId) async {
    if (bookmarkedArticleIds.contains(articleId)) {
      await _removeBookmark(articleId);
      bookmarkedArticleIds.remove(articleId);
    } else {
      await _bookmarkArticle(articleId);
      bookmarkedArticleIds.add(articleId);
    }

    await loadBookmarkedNews();
  }

  bool isBookmarked(String articleId) {
    return bookmarkedArticleIds.contains(articleId);
  }

  void loadBookmarks() {
    final ids = _getBookmarkedIds();

    bookmarkedArticleIds.assignAll(ids);
  }

  Future<void> loadBookmarkedNews() async {
    try {
      final result = await _getBookmarkedNews();

      bookmarkedArticles.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }
}