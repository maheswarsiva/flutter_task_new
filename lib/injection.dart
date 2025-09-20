import 'package:get_it/get_it.dart';
import 'data/datasources/firebase_auth_datasource.dart';
import 'data/datasources/firebase_storage_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/file_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/file_repository.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/file_provider.dart';

final sl = GetIt.instance;

Future<void> initInjection() async {
  // Data sources
  sl.registerLazySingleton<FirebaseAuthDataSource>(() => FirebaseAuthDataSource());
  sl.registerLazySingleton<FirebaseStorageDataSource>(() => FirebaseStorageDataSource());

  // Repositories - note FileRepositoryImpl is injected with AuthRepository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl<FirebaseAuthDataSource>()));
  sl.registerLazySingleton<FileRepository>(() => FileRepositoryImpl(sl<FirebaseStorageDataSource>(), sl<AuthRepository>()));

  // Providers
  sl.registerFactory(() => AuthProvider(sl<AuthRepository>()));
  sl.registerFactory(() => FileProvider(sl<FileRepository>(), sl<AuthRepository>()));
}