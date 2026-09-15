import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../domain/entities/article_entity.dart';

class ArticleCard extends StatefulWidget {
  const ArticleCard({
    super.key,
    required this.article,
    required this.isBookmarked,
    required this.onBookmarkPressed,
    required this.onTap,
  });

  final ArticleEntity article;
  final bool isBookmarked;
  final VoidCallback onBookmarkPressed;
  final VoidCallback onTap;

  @override
  State<ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  final FocusNode _cardFocusNode =
  FocusNode(debugLabel: 'ArticleCardFocusNode');
  final FocusNode _bookmarkFocusNode =
  FocusNode(debugLabel: 'BookmarkFocusNode');

  bool _isCardFocused = false;
  bool _isBookmarkFocused = false;

  @override
  void initState() {
    super.initState();
    _cardFocusNode.addListener(_handleCardFocusChange);
    _bookmarkFocusNode.addListener(_handleBookmarkFocusChange);
  }

  void _handleCardFocusChange() {
    setState(() {
      _isCardFocused = _cardFocusNode.hasFocus;
    });
  }

  void _handleBookmarkFocusChange() {
    setState(() {
      _isBookmarkFocused = _bookmarkFocusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _cardFocusNode.removeListener(_handleCardFocusChange);
    _bookmarkFocusNode.removeListener(_handleBookmarkFocusChange);
    _cardFocusNode.dispose();
    _bookmarkFocusNode.dispose();
    super.dispose();
  }

  String _buildSemanticLabel(ArticleEntity article) {
    final buffer = StringBuffer()
      ..write(article.title)
      ..write('. ')
      ..write(article.description);

    if (article.categories.isNotEmpty) {
      buffer.write(
        '. ${AppStrings.categoriesLabel}: ${article.categories.join(', ')}',
      );
    }

    buffer.write('. ${AppStrings.sourceLabel}: ${article.author}');

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;

    return Semantics(
      label: _buildSemanticLabel(article),
      hint: AppStrings.articleCardSemanticHint,
      button: true,
      container: true,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isCardFocused ? AppColors.focusColor : AppColors.divider,
            width: _isCardFocused ? 2 : 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            focusNode: _cardFocusNode,
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ExcludeSemantics(
                          child: Text(
                            article.title,
                            style: AppTextStyles.title,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Semantics(
                        label: widget.isBookmarked
                            ? AppStrings.removeBookmarkSemanticLabel
                            : AppStrings.addBookmarkSemanticLabel,
                        hint: AppStrings.bookmarkToggleSemanticHint,
                        button: true,
                        container: true,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _isBookmarkFocused
                                  ? AppColors.focusColor
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            shape: const CircleBorder(),
                            child: InkWell(
                              focusNode: _bookmarkFocusNode,
                              onTap: widget.onBookmarkPressed,
                              customBorder: const CircleBorder(),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  widget.isBookmarked
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: widget.isBookmarked
                                      ? AppColors.bookmarkActive
                                      : AppColors.bookmarkInactive,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ExcludeSemantics(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.description,
                        ),
                        if (article.categories.isNotEmpty) ...[
                          const SizedBox(height: 10),
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
                                  color: AppColors.background,
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
                        const SizedBox(height: 14),
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
                            Text(
                              article.author,
                              style: AppTextStyles.metadata,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}