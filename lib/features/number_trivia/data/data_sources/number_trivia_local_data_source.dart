import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [NoLocalDataException] if no cached data is present.
  Future<NumberTriviaModel> getCachedDataFromLocalStorage();

  Future<void> cachingData(NumberTriviaModel numberTriviaModel);
}

const String trivia_number_cached = 'TRIVIA_NUMBER_CACHED';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({@required this.sharedPreferences});
  @override
  Future<void> cachingData(NumberTriviaModel numberTriviaModel) {
    final jsonString = json.encode(numberTriviaModel.toJson(numberTriviaModel));
    return Future.value(
        sharedPreferences.setString(trivia_number_cached, jsonString));
  }

  @override
  Future<NumberTriviaModel> getCachedDataFromLocalStorage() {
    final String jsonMap = sharedPreferences.getString(trivia_number_cached);
    if (jsonMap != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonMap)));
    } else {
      throw CacheException();
    }
  }
}
