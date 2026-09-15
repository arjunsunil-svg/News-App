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
          _FocusableIconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Get.toNamed(AppRoutes.bookmarks);
            },
            semanticLabel: AppStrings.bookmarksNavSemanticLabel,
            semanticHint: AppStrings.bookmarksNavSemanticHint,
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
            child: Semantics(
              label: AppStrings.searchFieldSemanticLabel,
              hint: AppStrings.searchFieldSemanticHint,
              textField: true,
              excludeSemantics: true,
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
                      color: AppColors.focusColor,
                      width: 1.5,
                    ),
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

                    return _CategoryChip(
                      label: category,
                      isSelected: isSelected,
                      onSelected: () => controller.selectCategory(category),
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
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.articleDetails,
                          arguments: article,
                        );
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

class _CategoryChip extends StatefulWidget {
  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  State<_CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<_CategoryChip> {
  final FocusNode _focusNode = FocusNode(debugLabel: 'CategoryChipFocusNode');

  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.label,
      hint: AppStrings.categoryChipSemanticHint,
      selected: widget.isSelected,
      button: true,
      container: true,
      excludeSemantics: true,
      child: ChoiceChip(
        focusNode: _focusNode,
        label: Text(widget.label),
        selected: widget.isSelected,
        onSelected: (_) => widget.onSelected(),
        showCheckmark: false,
        labelStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color:
          widget.isSelected ? AppColors.surface : AppColors.textPrimary,
        ),
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary,
        side: BorderSide(
          color: _isFocused
              ? AppColors.focusColor
              : (widget.isSelected ? AppColors.primary : AppColors.divider),
          width: _isFocused ? 2 : 1,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }
}

class _FocusableIconButton extends StatefulWidget {
  const _FocusableIconButton({
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    required this.semanticHint,
  });

  final Widget icon;
  final VoidCallback onPressed;
  final String semanticLabel;
  final String semanticHint;

  @override
  State<_FocusableIconButton> createState() => _FocusableIconButtonState();
}

class _FocusableIconButtonState extends State<_FocusableIconButton> {
  final FocusNode _focusNode =
  FocusNode(debugLabel: 'FocusableIconButtonFocusNode');

  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel,
      hint: widget.semanticHint,
      button: true,
      container: true,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: _isFocused ? AppColors.focusColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            focusNode: _focusNode,
            onTap: widget.onPressed,
            customBorder: const CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: widget.icon,
            ),
          ),
        ),
      ),
    );
  }
}