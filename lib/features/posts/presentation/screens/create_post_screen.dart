import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../domain/entities/post_entity.dart';
import '../controllers/post_controller.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final PostController controller = Get.find<PostController>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  final FocusNode _submitFocusNode =
  FocusNode(debugLabel: 'SubmitPostFocusNode');

  bool _isSubmitFocused = false;

  @override
  void initState() {
    super.initState();
    _submitFocusNode.addListener(_handleSubmitFocusChange);
  }

  void _handleSubmitFocusChange() {
    setState(() {
      _isSubmitFocused = _submitFocusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _submitFocusNode.removeListener(_handleSubmitFocusChange);
    _submitFocusNode.dispose();
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.createPostTitle),
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
            Semantics(
              label: AppStrings.postTitleFieldSemanticLabel,
              hint: AppStrings.postTitleFieldSemanticHint,
              textField: true,
              excludeSemantics: true,
              child: TextField(
                controller: _titleController,
                style: const TextStyle(color: AppColors.textPrimary),
                cursorColor: AppColors.primary,
                decoration: InputDecoration(
                  hintText: AppStrings.postTitleHint,
                  hintStyle: const TextStyle(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
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
            const SizedBox(height: 14),
            Semantics(
              label: AppStrings.postBodyFieldSemanticLabel,
              hint: AppStrings.postBodyFieldSemanticHint,
              textField: true,
              excludeSemantics: true,
              child: TextField(
                controller: _bodyController,
                maxLines: 5,
                style: const TextStyle(color: AppColors.textPrimary),
                cursorColor: AppColors.primary,
                decoration: InputDecoration(
                  hintText: AppStrings.postBodyHint,
                  hintStyle: const TextStyle(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.surface,
                  contentPadding: const EdgeInsets.all(14),
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
            const SizedBox(height: 20),
            Obx(() {
              return Semantics(
                label: AppStrings.submitPost,
                hint: AppStrings.submitPostSemanticHint,
                button: true,
                container: true,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _isSubmitFocused
                          ? AppColors.focusColor
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      focusNode: _submitFocusNode,
                      onPressed: controller.isSubmitting.value
                          ? null
                          : () {
                        controller.submitPost(
                          title: _titleController.text.trim(),
                          body: _bodyController.text.trim(),
                        );
                      },
                      child: ExcludeSemantics(
                        child: controller.isSubmitting.value
                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.surface,
                          ),
                        )
                            : const Text(AppStrings.submitPost),
                      ),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            Obx(() {
              final post = controller.createdPost.value;
              final error = controller.errorMessage.value;

              if (error != null) {
                return _PostResultCard(
                  semanticLabel: '${AppStrings.postCreationError}. $error',
                  child: Text(
                    '${AppStrings.postCreationError}: $error',
                    style: AppTextStyles.error,
                  ),
                );
              }

              if (post != null) {
                return _PostResultCard(
                  semanticLabel:
                  '${AppStrings.postCreatedSuccess}. ${AppStrings.postIdLabel}: ${post.id}. ${post.title}. ${post.body}',
                  child: _PostResultContent(post: post),
                );
              }

              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}

class _PostResultContent extends StatelessWidget {
  const _PostResultContent({required this.post});

  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.postCreatedSuccess,
          style: AppTextStyles.title,
        ),
        const SizedBox(height: 8),
        Text(
          '${AppStrings.postIdLabel}: ${post.id}',
          style: AppTextStyles.metadata,
        ),
        const SizedBox(height: 4),
        Text(
          post.title,
          style: AppTextStyles.title,
        ),
        const SizedBox(height: 4),
        Text(
          post.body,
          style: AppTextStyles.description,
        ),
      ],
    );
  }
}

class _PostResultCard extends StatefulWidget {
  const _PostResultCard({
    required this.semanticLabel,
    required this.child,
  });

  final String semanticLabel;
  final Widget child;

  @override
  State<_PostResultCard> createState() => _PostResultCardState();
}

class _PostResultCardState extends State<_PostResultCard> {
  final FocusNode _focusNode =
  FocusNode(debugLabel: 'PostResultCardFocusNode');

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
      container: true,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _isFocused ? AppColors.focusColor : AppColors.divider,
            width: _isFocused ? 2 : 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            focusNode: _focusNode,
            onTap: () {},
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: ExcludeSemantics(
                child: widget.child,
              ),
            ),
          ),
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