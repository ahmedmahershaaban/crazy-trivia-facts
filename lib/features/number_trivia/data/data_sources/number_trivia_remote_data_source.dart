import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// throw an [ServerException] for all error codes . <NumberTriviaModel>
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// calls the http://numbersapi.com/random endpoint
  ///
  /// throw an [ServerException] for all error codes . <NumberTriviaModel>
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({
    @required this.client,
  });

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) {
    return _getNumberTrivia('http://numbersapi.com/$number');
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() {
    return _getNumberTrivia('http://numbersapi.com/random');
  }

  Future<NumberTriviaModel> _getNumberTrivia(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw (ServerException());
    }
  }
}
