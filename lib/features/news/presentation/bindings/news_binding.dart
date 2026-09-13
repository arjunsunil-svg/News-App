import 'package:get/get.dart';

import '../../../../core/graphql/graphql_service.dart';
import '../../../../core/storage/hive_storage.dart';
import '../../data/datasources/news_local_datasource.dart';
import '../../data/datasources/news_remote_datasource.dart';
import '../../data/repositories/news_repository_impl.dart';
import '../../domain/repositories/news_repository.dart';
import '../../domain/usecases/bookmark_article.dart';
import '../../domain/usecases/get_bookmarked_ids.dart';
import '../../domain/usecases/get_bookmarked_news.dart';
import '../../domain/usecases/get_news.dart';
import '../../domain/usecases/remove_bookmark.dart';
import '../controllers/news_controller.dart';

class NewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GraphQLService>(
          () => GraphQLService(),
    );

    Get.lazyPut<NewsRemoteDataSource>(
          () => NewsRemoteDataSource(
        Get.find<GraphQLService>(),
      ),
    );

    Get.lazyPut<NewsLocalDataSource>(
          () => NewsLocalDataSource(
        HiveStorage.instance,
      ),
    );

    Get.lazyPut<NewsRepository>(
          () => NewsRepositoryImpl(
        Get.find<NewsRemoteDataSource>(),
        Get.find<NewsLocalDataSource>(),
      ),
    );

    Get.lazyPut<GetNews>(
          () => GetNews(
        Get.find<NewsRepository>(),
      ),
    );

    Get.lazyPut<BookmarkArticle>(
          () => BookmarkArticle(
        Get.find<NewsRepository>(),
      ),
    );

    Get.lazyPut<RemoveBookmark>(
          () => RemoveBookmark(
        Get.find<NewsRepository>(),
      ),
    );

    Get.lazyPut<GetBookmarkedIds>(
          () => GetBookmarkedIds(
        Get.find<NewsRepository>(),
      ),
    );


    Get.lazyPut<GetBookmarkedNews>(
          () => GetBookmarkedNews(
        Get.find<NewsRepository>(),
      ),
    );

    Get.lazyPut<NewsController>(
          () => NewsController(
        getNews: Get.find<GetNews>(),
        bookmarkArticle: Get.find<BookmarkArticle>(),
        removeBookmark: Get.find<RemoveBookmark>(),
        getBookmarkedIds: Get.find<GetBookmarkedIds>(),
        getBookmarkedNews: Get.find<GetBookmarkedNews>(),
      ),
    );
  }
}