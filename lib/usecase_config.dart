import 'data/datasources/post_remote_data_source.dart';
import 'data/repositories/post_repository_impl.dart';
import 'domain/usecases/get_posts_usecase.dart';

class UsecaseConfig {
  GetPostsUsecase? getPostsUsecase;
  PostRepositoryImpl? postRepositoryImpl;
  PostRemoteDataSourceImp? postRemoteDataSourceImp;

  UsecaseConfig() {
    postRemoteDataSourceImp = PostRemoteDataSourceImp();
    postRepositoryImpl =
        PostRepositoryImpl(postRemoteDataSource: postRemoteDataSourceImp!);
    getPostsUsecase = GetPostsUsecase(postRepositoryImpl!);
  }
}
