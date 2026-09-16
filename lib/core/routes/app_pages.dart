import 'package:get/get.dart';
import '../../features/news/presentation/bindings/news_binding.dart';
import '../../features/news/presentation/screens/news_screen.dart';
import '../../features/news/presentation/screens/bookmarks_screen.dart';
import '../../features/news/presentation/screens/article_details_screen.dart';
import '../../features/posts/presentation/bindings/post_binding.dart';
import '../../features/posts/presentation/screens/create_post_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = <GetPage>[
    GetPage(
      name: AppRoutes.news,
      page: () => const NewsScreen(),
      binding: NewsBinding(),
    ),
    GetPage(
      name: AppRoutes.bookmarks,
      page: () => const BookmarksScreen(),
      binding: NewsBinding(),
    ),
    GetPage(
      name: AppRoutes.articleDetails,
      page: () => const ArticleDetailsScreen(),
    ),
    GetPage(
      name: AppRoutes.createPost,
      page: () => const CreatePostScreen(),
      binding: PostBinding(),
    ),
  ];
}