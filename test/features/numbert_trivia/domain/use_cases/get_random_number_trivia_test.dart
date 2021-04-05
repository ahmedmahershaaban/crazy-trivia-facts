import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/use_case/use_case.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';

class MocNumberTriviaRepository extends Mock implements NumberTriviaRepository {
}

void main() {
  MocNumberTriviaRepository mocNumberTriviaRepository;
  GetRandomNumberTrivia useCase;

  setUp(() {
    mocNumberTriviaRepository = MocNumberTriviaRepository();
    useCase = GetRandomNumberTrivia(mocNumberTriviaRepository);
  });

  final tNumberTrivia = NumberTrivia(number: 5, text: 'this is test');
  test('Should get random number trivia from repository', () async {
    //assets

    when(mocNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => Right(tNumberTrivia));

    //act
    final result = await useCase(NoParams());

    //expect
    expect(result, Right(tNumberTrivia));
    verify(mocNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mocNumberTriviaRepository);
  });
}
