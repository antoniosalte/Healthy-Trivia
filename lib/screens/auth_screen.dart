import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:healthytrivia/providers/auth_provider.dart';
import 'package:healthytrivia/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    signInAnonymously();
    super.initState();
  }

  Future<void> signInAnonymously() async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signInAnonymously();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(8, 32, 8, 32),
        child: Center(
          child: SvgPicture.asset(
            'assets/images/logo.svg',
            height: 150,
          ),
        ),
      ),
    );
  }
}
