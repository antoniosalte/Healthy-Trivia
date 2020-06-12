import 'package:flutter/material.dart';

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
