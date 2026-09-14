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
              14,
              16,
              10,
            ),
            child: TextField(
              onChanged: controller.search,
              style: const TextStyle(color: AppColors.textPrimary),
              cursorColor: AppColors.primary,
              decoration: InputDecoration(
                hintText: AppStrings.searchHint,
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.accent,
                ),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: SizedBox(
              height: 36,
              child: Obx(() {
                final categories = controller.categories;
                final selected = controller.selectedCategory.value;

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = category == selected;

                    return ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (_) => controller.selectCategory(category),
                      showCheckmark: false,
                      labelStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.surface
                            : AppColors.textPrimary,
                      ),
                      backgroundColor: AppColors.surface,
                      selectedColor: AppColors.primary,
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.divider,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    );
                  },
                );
              }),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );
              }

              if (controller.errorMessage.value != null) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.wifi_off_rounded,
                        size: 40,
                        color: AppColors.accent,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        AppStrings.errorLoadingNews,
                        style: AppTextStyles.error,
                      ),
                      const SizedBox(height: 16),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.article_outlined,
                        size: 40,
                        color: AppColors.bookmarkInactive,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        controller.searchQuery.value.isEmpty
                            ? AppStrings.noArticles
                            : AppStrings.noSearchResults,
                        style: AppTextStyles.emptyState,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 12),
                itemCount: controller.articles.length,
                itemBuilder: (context, index) {
                  final article = controller.articles[index];

                  return Obx(() {
                    return ArticleCard(
                      article: article,
                      isBookmarked: controller.isBookmarked(article.id),
                      onBookmarkPressed: () {
                        controller.toggleBookmark(article.id);
                      },
                    );
                  });
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}