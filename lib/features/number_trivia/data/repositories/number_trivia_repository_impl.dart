import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

typedef Future<NumberTriviaModel> __ConcreteOrRemote();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource numberTriviaRemoteDataSource;
  final NumberTriviaLocalDataSource numberTriviaLocalDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    @required this.numberTriviaRemoteDataSource,
    @required this.numberTriviaLocalDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(number) async {
    return getConcreteOrRandomNumber(() {
      return numberTriviaRemoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return getConcreteOrRandomNumber(() {
      return numberTriviaRemoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> getConcreteOrRandomNumber(
      __ConcreteOrRemote concreteOrRemote) async {
    if (await networkInfo.isConnected) {
      try {
        final numberTriviaModel = await concreteOrRemote();
        numberTriviaLocalDataSource.cachingData(numberTriviaModel);
        return Right(numberTriviaModel);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        return Right(
            await numberTriviaLocalDataSource.getCachedDataFromLocalStorage());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
