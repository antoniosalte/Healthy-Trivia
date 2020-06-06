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
      appBar: AppBar(
        title: Text('DifficultyScreen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Dificultad'),
            _buildOptions(),
            RaisedButton(
              child: Text('Empezar'),
              onPressed: createGame,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOptions() {
    return Column(
      children: <Widget>[
        RadioListTile<int>(
          title: Text('Básico'),
          value: 0,
          groupValue: _difficulty,
          onChanged: (int value) {
            setState(() {
              _difficulty = value;
            });
          },
        ),
        RadioListTile<int>(
          title: Text('Intermedio'),
          value: 1,
          groupValue: _difficulty,
          onChanged: (int value) {
            setState(() {
              _difficulty = value;
            });
          },
        ),
        RadioListTile<int>(
          title: Text('Avanzado'),
          value: 2,
          groupValue: _difficulty,
          onChanged: (int value) {
            setState(() {
              _difficulty = value;
            });
          },
        ),
      ],
    );
  }
}
