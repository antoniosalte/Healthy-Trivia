import 'package:flutter/material.dart';

/// Widget creado para los títulos dentro de las pantallas de la aplicación.
class TitleWidget extends StatelessWidget {
  TitleWidget({this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline4,
    );
  }
}
