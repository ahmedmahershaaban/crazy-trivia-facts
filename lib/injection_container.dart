import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'core/util/input_converter.dart';
import 'features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // features
  sl.registerFactory(() => NumberTriviaBloc(
        concrete: sl(),
        random: sl(),
        inputConverter: sl(),
      ));

  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  sl.registerLazySingleton<NumberTriviaRepository>(
      () => NumberTriviaRepositoryImpl(
            numberTriviaRemoteDataSource: sl(),
            numberTriviaLocalDataSource: sl(),
            networkInfo: sl(),
          ));

  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));

  // core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(dataConnectionChecker: sl()));

  //external
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
