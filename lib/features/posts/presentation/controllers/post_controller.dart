import 'package:get/get.dart';

import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/create_post.dart';

class PostController extends GetxController {
  PostController({required CreatePost createPost}) : _createPost = createPost;

  final CreatePost _createPost;

  final isSubmitting = false.obs;

  final Rxn<PostEntity> createdPost = Rxn<PostEntity>();

  final errorMessage = RxnString();

  Future<void> submitPost({
    required String title,
    required String body,
  }) async {
    isSubmitting.value = true;
    errorMessage.value = null;
    createdPost.value = null;

    try {
      final result = await _createPost(title: title, body: body);
      createdPost.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isSubmitting.value = false;
    }
  }
}