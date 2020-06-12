import 'package:flutter/material.dart';
import 'package:healthytrivia/screens/game_screen.dart';
import 'package:healthytrivia/services/singleton.dart';

class DifficultyScreen extends StatefulWidget {
  @override
  _DifficultyScreenState createState() => _DifficultyScreenState();
}

class _DifficultyScreenState extends State<DifficultyScreen> {
  Singleton _singleton = Singleton();

  int _difficulty = 0;

  Future<void> createGame() async {
    await _singleton.createGame(_difficulty);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.only(bottom: 48),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Text('Seleccione la dificultad'),
            ),
            Align(
              alignment: Alignment.center,
              child: _buildOptions(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                child: Text('Empezar'),
                onPressed: createGame,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptions() {
    return Container(
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RadioListTile<int>(
            title: Text(
              'Básico',
              textAlign: TextAlign.center,
            ),
            value: 0,
            groupValue: _difficulty,
            onChanged: (int value) {
              setState(() {
                _difficulty = value;
              });
            },
          ),
          RadioListTile<int>(
            title: Text(
              'Intermedio',
              textAlign: TextAlign.center,
            ),
            value: 1,
            groupValue: _difficulty,
            onChanged: (int value) {
              setState(() {
                _difficulty = value;
              });
            },
          ),
          RadioListTile<int>(
            title: Text(
              'Avanzado',
              textAlign: TextAlign.center,
            ),
            value: 2,
            groupValue: _difficulty,
            onChanged: (int value) {
              setState(() {
                _difficulty = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
