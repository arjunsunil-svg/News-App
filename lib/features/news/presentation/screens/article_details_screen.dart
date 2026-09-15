import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../domain/entities/article_entity.dart';

class ArticleDetailsScreen extends StatelessWidget {
  const ArticleDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final article = Get.arguments as ArticleEntity;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.articleDetailsTitle),
        leading: _FocusableIconButton(
          icon: const BackButtonIcon(),
          onPressed: () => Get.back(),
          semanticLabel: AppStrings.backButtonSemanticLabel,
          semanticHint: AppStrings.backButtonSemanticHint,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                article.imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: AppColors.surface,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.textSecondary,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              article.title,
              style: AppTextStyles.title,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${AppStrings.sourceLabel}: ${article.author}',
                    style: AppTextStyles.metadata,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${AppStrings.publishedLabel}: '
                  '${article.publishedAt.day}/${article.publishedAt.month}/${article.publishedAt.year}',
              style: AppTextStyles.metadata,
            ),
            if (article.categories.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                AppStrings.categoriesLabel,
                style: AppTextStyles.metadata,
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: article.categories.map((category) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Text(
                      category,
                      style: AppTextStyles.metadata,
                    ),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              article.description,
              style: AppTextStyles.description,
            ),
            const SizedBox(height: 12),
            Text(
              article.content.isNotEmpty
                  ? article.content
                  : AppStrings.noContentAvailable,
              style: AppTextStyles.description,
            ),
            const SizedBox(height: 16),
            Text(
              article.url,
              style: AppTextStyles.metadata.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
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