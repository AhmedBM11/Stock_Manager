import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sat/logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:sat/logic/blocs/auth_bloc/auth_state.dart';

import 'package:sat/navigator/navigator_one.dart';
import 'package:sat/views/pages/page_one/welcome_page.dart';
//import 'navigator/router_one.dart';

class App extends StatelessWidget {
  /*final AppRouter appRouter;*/
  const App({super.key/*, required this.appRouter*/});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Stock Manager",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      home: NavigatorOne(),
    );
  }
}
