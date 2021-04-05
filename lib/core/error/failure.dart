import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final int = 4;
  @override
  // TODO: implement props
  List<Object> get props => [int];
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class InvalidInputFailure extends Failure {}
