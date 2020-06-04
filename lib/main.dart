import 'package:flutter/material.dart';
import 'package:healthytrivia/providers/auth_provider.dart';
import 'package:healthytrivia/screens/auth_screen.dart';
import 'package:healthytrivia/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthManager(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class AuthManager extends StatelessWidget {
  AuthManager({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: true);

    if (authProvider.isAuthenticated) {
      return HomeScreen();
    } else {
      return AuthScreen();
    }
  }

  //   if (authProvider.isAuthenticated) {
  //     body = Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[Text('Authenticated')],
  //     );
  //   } else {
  //     body = Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[Text('Unauthenticated')],
  //     );
  //   }

  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     appBar: AppBar(
  //       title: Text(title),
  //       centerTitle: true,
  //     ),
  //     body: body,
  //     floatingActionButton: Column(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       children: <Widget>[
  //         (!authProvider.isAuthenticated
  //             ? FloatingActionButton(
  //                 onPressed: () {
  //                   authProvider.signInAnonymously();
  //                 },
  //                 tooltip: 'Sign In Anonymously',
  //                 child: Icon(Icons.account_circle),
  //               )
  //             : FloatingActionButton(
  //                 onPressed: () {
  //                   authProvider.signOut();
  //                 },
  //                 tooltip: 'Sign Out',
  //                 child: Icon(Icons.exit_to_app),
  //               ))
  //       ],
  //     ),
  //   );
  // }
}
