import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/failure.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String number) {
    try {
      final int parsedNumber = int.parse(number);
      if (parsedNumber < 0) throw FormatException();
      return Right(parsedNumber);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}
