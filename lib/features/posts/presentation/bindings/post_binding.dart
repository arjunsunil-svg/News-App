import 'package:get/get.dart';

import '../../../../core/graphql/graphql_http_executor.dart';
import '../../../../core/graphql/graphql_service.dart';
import '../../data/datasources/post_remote_datasource.dart';
import '../../data/repositories/post_repository_impl.dart';
import '../../domain/repositories/post_repository.dart';
import '../../domain/usecases/create_post.dart';
import '../controllers/post_controller.dart';

class PostBinding extends Bindings {
  static const String graphQLServiceTag = 'postsGraphQLService';

  @override
  void dependencies() {
    Get.lazyPut<GraphQLService>(
          () => GraphQLService(
        executor: const GraphQLHttpExecutor(
          'https://graphqlzero.almansi.me/api',
        ),
      ),
      tag: graphQLServiceTag,
    );

    Get.lazyPut<PostRemoteDataSource>(
          () => PostRemoteDataSource(
        Get.find<GraphQLService>(tag: graphQLServiceTag),
      ),
    );

    Get.lazyPut<PostRepository>(
          () => PostRepositoryImpl(
        Get.find<PostRemoteDataSource>(),
      ),
    );

    Get.lazyPut<CreatePost>(
          () => CreatePost(
        Get.find<PostRepository>(),
      ),
    );

    Get.lazyPut<PostController>(
          () => PostController(
        createPost: Get.find<CreatePost>(),
      ),
    );
  }
}