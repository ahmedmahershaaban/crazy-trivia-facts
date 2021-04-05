import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });
  group('getCachedDataFromLocalStorage', () {
    const String trivia_number_cached = 'TRIVIA_NUMBER_CACHED';
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached')));

    test(
        'Should return NumberTrivia from jsonData when there is shared preferences is there',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cached'));
      // act
      final result = await dataSource.getCachedDataFromLocalStorage();
      //assert
      verify(mockSharedPreferences.getString(trivia_number_cached));
      expect(result, equals(tNumberTriviaModel));
    });

    test('Should return CacheException When there is no data cached before!',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      // act
      final call = dataSource.getCachedDataFromLocalStorage;

      //assert
      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });

  group('cachingData', () {
    const String trivia_number_cached = 'TRIVIA_NUMBER_CACHED';
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached')));
    final jsonString =
        json.encode(tNumberTriviaModel.toJson(tNumberTriviaModel));

    test(
        'Should call sharedPreferences.setString with the same trivia_number_cached constant',
        () async {
      // arrange
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      // act
      dataSource.cachingData(tNumberTriviaModel);
      //assert
      verify(mockSharedPreferences.setString(trivia_number_cached, jsonString));
    });
  });
}
