import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../controllers/news_controller.dart';
import '../widgets/article_card.dart';

class NewsScreen extends GetView<NewsController> {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.appTitle),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.bookmarks);
            },
            icon: const Icon(Icons.bookmark),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              12,
              16,
              8,
            ),
            child: TextField(
              onChanged: controller.search,
              decoration: InputDecoration(
                hintText: AppStrings.searchHint,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.errorMessage.value != null) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppStrings.errorLoadingNews,
                        style: AppTextStyles.error,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: controller.loadNews,
                        child: const Text(AppStrings.retry),
                      ),
                    ],
                  ),
                );
              }

              if (controller.articles.isEmpty) {
                return Center(
                  child: Text(
                    controller.searchQuery.value.isEmpty
                        ? AppStrings.noArticles
                        : AppStrings.noSearchResults,
                  ),
                );
              }

              return ListView.builder(
                itemCount: controller.articles.length,
                itemBuilder: (context, index) {
                  final article = controller.articles[index];

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
          ),
        ],
      ),
    );
  }
}
