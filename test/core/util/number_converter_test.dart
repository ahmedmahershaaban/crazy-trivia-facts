import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/core/util/input_converter.dart';

void main() {
  InputConverter numberConverter;
  setUp(() {
    numberConverter = InputConverter();
  });

  group('convertStringToUnsignedNumber', () {
    test('Should return int number when passing unsigned number string',
        () async {
      // arrange
      final number = '123';
      // act
      final result = numberConverter.stringToUnsignedInteger(number);
      //assert
      expect(result, Right(123));
    });

    test('Should return InvalidInputFailure  when the string is not a number',
        () async {
      // arrange
      final number = 'asd';
      // act
      final result = numberConverter.stringToUnsignedInteger(number);
      //assert
      expect(result, Left(InvalidInputFailure()));
    });
    test('Should return InvalidInputFailure  when the number is negative ',
        () async {
      // arrange
      final number = '-253';
      // act
      final result = numberConverter.stringToUnsignedInteger(number);
      //assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
