import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../controllers/news_controller.dart';
import '../widgets/article_card.dart';

class BookmarksScreen extends GetView<NewsController> {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.loadBookmarkedNews();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.bookmarks),
      ),
      body: Obx(() {
        if (controller.bookmarkedArticles.isEmpty) {
          return const Center(
            child: Text(AppStrings.noBookmarks),
          );
        }

        return ListView.builder(
          itemCount: controller.bookmarkedArticles.length,
          itemBuilder: (context, index) {
            final article = controller.bookmarkedArticles[index];

            return ArticleCard(
              article: article,
              isBookmarked: controller.isBookmarked(article.id),
              onBookmarkPressed: () {
                controller.toggleBookmark(article.id);
              },
            );
          },
        );
      }),
    );
  }
}