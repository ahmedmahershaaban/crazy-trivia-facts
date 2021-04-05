import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

class MockNumberTriviaRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockNumberTriviaLocalDataSource extends Mock
    implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

main() {
  NumberTriviaRepositoryImpl repository;
  MockNumberTriviaLocalDataSource mockLocalDataSource;
  MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      numberTriviaRemoteDataSource: mockRemoteDataSource,
      numberTriviaLocalDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  }); //setUp

  group('GetConcreteNumberTrivia', () {
    final int tNumber = 1;
    final NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: 'test trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('Should check if the device is connected ! ', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    group('Online device', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'Should return remote data when the call to remote data is successful ',
          () async {
        // arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        expect(result, Right(tNumberTrivia));
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      });

      test('Should cache data when the call to remote data is successful ',
          () async {
        // arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource.cachingData(tNumberTriviaModel));
      });

      test(
          'Should return server failure when the call to remote data is unsuccessful ',
          () async {
        // arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        expect(result, Left(ServerFailure()));
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
      });
    });

    group('Offline device', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
          'Should return cached data when There is no Connection & there is a cached data ',
          () async {
        // arrange
        when(mockLocalDataSource.getCachedDataFromLocalStorage())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        expect(result, Right(tNumberTrivia));
        verify(mockLocalDataSource.getCachedDataFromLocalStorage());
        verifyZeroInteractions(mockRemoteDataSource);
      });
      test(
          'Should return cache failure when There is no Connection & there is no cached data',
          () async {
        // arrange
        when(mockLocalDataSource.getCachedDataFromLocalStorage())
            .thenThrow(CacheException());
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        expect(result, Left(CacheFailure()));
        verify(mockLocalDataSource.getCachedDataFromLocalStorage());
        verifyZeroInteractions(mockRemoteDataSource);
      });
    });
  }); // Group of GetConcreteNumberTrivia

  group('GetRandomNumberTrivia', () {
    test('Should check if the device is connected! ', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      // act
      repository.getRandomNumberTrivia();
      //assert
      verify(mockNetworkInfo.isConnected);
    });
    group('Online device', () {
      final NumberTriviaModel tNumberTriviaModel =
          NumberTriviaModel(number: 1, text: 'test trivia');
      final NumberTrivia tNumberTrivia = tNumberTriviaModel;
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
          'Should get remote data from the server when the request is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getRandomNumberTrivia();
        //assert
        expect(result, Right(tNumberTrivia));
      });
      test(
          'Should  cache data gotten from the server when the request is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        await repository.getRandomNumberTrivia();
        //assert
        verify(mockLocalDataSource.cachingData(tNumberTriviaModel));
      });
      test('Should  throw Server Error when the request is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        // act
        final result = await repository.getRandomNumberTrivia();
        //assert
        expect(result, Left(ServerFailure()));
      });
    });

    group('Offline device', () {
      final NumberTriviaModel tNumberTriviaModel =
          NumberTriviaModel(number: 1, text: 'test trivia');
      final NumberTrivia tNumberTrivia = tNumberTriviaModel;
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
          'Should return cached data from the storage when there is data cached found ',
          () async {
        // arrange
        when(mockLocalDataSource.getCachedDataFromLocalStorage())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getRandomNumberTrivia();
        //assert
        expect(result, Right(tNumberTrivia));
        verify(mockLocalDataSource.getCachedDataFromLocalStorage());
        verifyZeroInteractions(mockRemoteDataSource);
      });
      test(
          'Should return cache failure from the storage when there is No data cached  ',
          () async {
        // arrange
        when(mockLocalDataSource.getCachedDataFromLocalStorage())
            .thenThrow(CacheException());
        // act
        final result = await repository.getRandomNumberTrivia();
        //assert
        expect(result, Left(CacheFailure()));
        verify(mockLocalDataSource.getCachedDataFromLocalStorage());
        verifyZeroInteractions(mockRemoteDataSource);
      });
    });
  });
} //main
