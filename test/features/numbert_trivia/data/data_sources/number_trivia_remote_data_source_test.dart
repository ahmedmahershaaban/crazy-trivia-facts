import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia_int'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response('Sorry something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_int')));

    test(
        'Should check if the call to the API is made correctly with correct headers! ',
        () async {
      // arrange
      setUpMockHttpClientSuccess200();

      // act
      dataSource.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockHttpClient.get(
        Uri.parse('http://numbersapi.com/$tNumber'),
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('Should return an numberTriviaJson when the call to API is 200! ',
        () async {
      // arrange
      setUpMockHttpClientSuccess200();

      // act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      //assert
      expect(result, tNumberTriviaModel);
    });

    test('Should return an ServerException when the call to API is 404! ',
        () async {
      // arrange
      setUpMockHttpClientFailure404();
      // act
      final call = dataSource.getConcreteNumberTrivia;
      //assert
      expect(() => call(tNumber), throwsA(isA<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_int')));

    test(
        'Should check if the call to the API is made correctly with correct headers! ',
        () async {
      // arrange
      setUpMockHttpClientSuccess200();

      // act
      dataSource.getRandomNumberTrivia();
      //assert
      verify(mockHttpClient.get(
        Uri.parse('http://numbersapi.com/random'),
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('Should return an numberTriviaJson when the call to API is 200! ',
        () async {
      // arrange
      setUpMockHttpClientSuccess200();

      // act
      final result = await dataSource.getRandomNumberTrivia();
      //assert
      expect(result, tNumberTriviaModel);
    });

    test('Should return an ServerException when the call to API is 404! ',
        () async {
      // arrange
      setUpMockHttpClientFailure404();

      // act
      final call = dataSource.getRandomNumberTrivia;
      //assert
      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });
}
