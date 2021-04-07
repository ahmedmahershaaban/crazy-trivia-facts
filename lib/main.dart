import 'package:flutter/material.dart';
import 'package:number_trivia/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.green.shade700,
        accentColor: Colors.grey.shade500,
      ),
      home: NumberTriviaPage(),
    );
  }
}
