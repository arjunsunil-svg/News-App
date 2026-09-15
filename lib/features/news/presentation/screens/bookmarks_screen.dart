import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
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
        leading: _FocusableIconButton(
          icon: const BackButtonIcon(),
          onPressed: () => Get.back(),
          semanticLabel: AppStrings.backButtonSemanticLabel,
          semanticHint: AppStrings.backButtonSemanticHint,
        ),
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
              onTap: () {
                Get.toNamed(
                  AppRoutes.articleDetails,
                  arguments: article,
                );
              },
            );
          },
        );
      }),
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