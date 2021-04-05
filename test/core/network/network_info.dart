import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/network/network_info.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkInfoImpl networkInfoImpl;
  MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl =
        NetworkInfoImpl(dataConnectionChecker: mockDataConnectionChecker);
  });
  test('Should return future bool if there is an internet connection  ',
      () async {
    final tHasConnectionFuture = Future.value(true);
    // arrange
    when(mockDataConnectionChecker.hasConnection)
        .thenAnswer((_) => tHasConnectionFuture);
    // act
    final result = networkInfoImpl.isConnected;
    //assert
    verify(mockDataConnectionChecker.hasConnection);
    expect(result, tHasConnectionFuture);
  });
}
