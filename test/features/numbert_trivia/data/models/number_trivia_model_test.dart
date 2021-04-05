import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture.dart';

void main() {
  final NumberTriviaModel tNumberTriviaModel =
      NumberTriviaModel(number: 1, text: 'text test');

  test('should NumberTriviaModel extends NumberTrivia', () async {
    //assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('FromJson', () {
    test('should return NumberTriviaModel when the response is with int number',
        () async {
      //arrange
      final Map<String, dynamic> jsonMap = jsonDecode(fixture('trivia_int'));
      // act
      final result = NumberTriviaModel.fromJson(jsonMap);

      //assert
      expect(result, tNumberTriviaModel);
    });
    test(
        'should return NumberTriviaModel when the response is with double number',
        () async {
      //arrange
      final Map<String, dynamic> jsonMap = jsonDecode(fixture('trivia_double'));
      // act
      final result = NumberTriviaModel.fromJson(jsonMap);

      //assert
      expect(result, tNumberTriviaModel);
    });
  });

  group('toJson', () {
    test('should return jsonMap', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          tNumberTriviaModel.toJson(tNumberTriviaModel);

      // act
      final jsonMapMatcher = {'text': 'text test', 'number': 1};
      //assert
      expect(jsonMap, jsonMapMatcher);
    });
  });
}
