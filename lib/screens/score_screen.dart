import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthytrivia/models/ranking.dart';
import 'package:healthytrivia/services/game_service.dart';
import 'package:healthytrivia/widgets/title_widget.dart';
import 'package:screenshot/screenshot.dart';

class ScoreScreen extends StatefulWidget {
  final Ranking currentRanking;

  ScoreScreen({Key key, this.currentRanking}) : super(key: key);

  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  GameService _gameService = GameService();
  List<Ranking> ranking = List<Ranking>();

  bool _rankingBool = false;

  ScreenshotController _screenshotController = ScreenshotController();
  @override
  void initState() {
    super.initState();
  }

  void goToHome() {
    Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
  }

  Future<void> getRanking() async {
    if (ranking.length == 0) {
      ranking = await _gameService.getRanking();
    }
    setState(() {
      _rankingBool = true;
    });
  }

  Future<void> share() async {
    try {
      File image = await _screenshotController.capture();
      Uint8List bytes = image.readAsBytesSync();
      await Share.file(
        'Puntaje',
        'puntaje.png',
        bytes,
        'image/png',
      );
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _buildLeading(),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: (_rankingBool ? _buildRanking() : _buildScore()),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    child: Text('Inicio'),
                    onPressed: goToHome,
                  ),
                  _buildAction(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeading() {
    return (_rankingBool
        ? IconButton(
            icon:
                Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
            onPressed: () {
              setState(() {
                _rankingBool = false;
              });
            },
          )
        : SizedBox(height: 0.0));
  }

  Widget _buildScore() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TitleWidget(title: '¡Felicidades!'),
        Text(
          widget.currentRanking.nickname,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        SizedBox(height: 32.0),
        Text(
          'Tu puntaje es:',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        Text(
          '${widget.currentRanking.score}',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }

  Widget _buildRanking() {
    return Screenshot(
      controller: _screenshotController,
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TitleWidget(title: 'RANKING'),
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.only(left: 48, right: 48),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Nickname',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          'Puntaje',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: ranking
                          .asMap()
                          .entries
                          .map(
                            (entry) => Container(
                              color: (widget.currentRanking.nickname ==
                                          entry.value.nickname &&
                                      widget.currentRanking.score ==
                                          entry.value.score)
                                  ? Theme.of(context).colorScheme.secondary
                                  : Colors.transparent,
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('${entry.value.nickname}'),
                                  Text('${entry.value.score}'),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAction() {
    return (_rankingBool
        ? RaisedButton.icon(
            icon: Icon(Platform.isIOS ? CupertinoIcons.share : Icons.share),
            label: Text('Compartir'),
            onPressed: share,
          )
        : RaisedButton(
            child: Text('Ranking'),
            onPressed: getRanking,
          ));
  }
}
