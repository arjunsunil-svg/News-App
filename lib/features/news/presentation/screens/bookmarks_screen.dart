import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_text_styles.dart';
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
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.bookmark_border,
                  size: 40,
                  color: AppColors.bookmarkInactive,
                ),
                const SizedBox(height: 10),
                Text(
                  AppStrings.noBookmarks,
                  style: AppTextStyles.emptyState,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 12),
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