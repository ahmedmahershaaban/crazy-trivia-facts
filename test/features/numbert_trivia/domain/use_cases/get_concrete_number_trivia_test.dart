import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';

class MocNumberTriviaRepository extends Mock implements NumberTriviaRepository {
}

void main() {
  MocNumberTriviaRepository mocNumberTriviaRepository;
  GetConcreteNumberTrivia useCase;

  setUp(() {
    mocNumberTriviaRepository = MocNumberTriviaRepository();
    useCase = GetConcreteNumberTrivia(mocNumberTriviaRepository);
  });

  final tNumber = 4;
  final tNumberTrivia = NumberTrivia(number: tNumber, text: 'this is test');
  test('Should get the trivial number from repository', () async {
    //assets

    when(mocNumberTriviaRepository.getConcreteNumberTrivia(any))
        .thenAnswer((_) async => Right(tNumberTrivia));

    //act
    final result = await useCase(Params(number: tNumber));

    //assert
    expect(result, Right(tNumberTrivia));
    verify(mocNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mocNumberTriviaRepository);
  });
}
