import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:number_trivia/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Number Trivia'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: BlocProvider(
              create: (context) => sl<NumberTriviaBloc>(),
              child: Column(
                children: [
                  BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                    builder: (context, state) {
                      print('Empty');
                      print(state is Empty);
                      print('Error');
                      print(state is Error);
                      print('Loading');
                      print(state is Loading);
                      print('Loaded');
                      print(state is Loaded);
                      print('*********************************************');
                      if (state is Empty) {
                        return DisplayMessage(message: 'Start Searching ...');
                      } else if (state is Error) {
                        return DisplayMessage(message: state.message);
                      } else if (state is Loading) {
                        return Loading();
                      } else if (state is Loaded) {
                        //Loaded
                        return Loaded(
                            numberTrivia:
                                NumberTrivia(number: 15, text: 'test trivia'));
                      } else {
                        return DisplayMessage(message: 'Error ... ');
                      }
                    },
                  ),
                  LogicUI()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LogicUI extends StatefulWidget {
  const LogicUI({
    Key key,
  }) : super(key: key);

  @override
  _LogicUIState createState() => _LogicUIState();
}

class _LogicUIState extends State<LogicUI> {
  final controller = TextEditingController();
  String numberStr;

  void getConcreteForNumberTrivia(String numberStr) {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(numberStr));
  }

  void getRandomForNumberTrivia() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 15,
        ),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onSubmitted: (_) {
            getConcreteForNumberTrivia(numberStr);
          },
          onChanged: (value) {
            setState(() {
              numberStr = value;
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Expanded(
              child: TextButton(
                child: Text(
                  'Search',
                ),
                style: ButtonStyle(),
                onPressed: () {
                  getConcreteForNumberTrivia(numberStr);
                },
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: TextButton(
                child: Text(
                  'Random Number',
                ),
                style: ButtonStyle(),
                onPressed: getRandomForNumberTrivia,
              ),
            ),
          ],
        )
      ],
    );
  }
}

class Loaded extends StatelessWidget {
  final NumberTrivia numberTrivia;
  const Loaded({
    Key key,
    @required this.numberTrivia,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                numberTrivia.number.toString(),
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                numberTrivia.text,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class DisplayMessage extends StatelessWidget {
  final String message;

  const DisplayMessage({
    Key key,
    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
