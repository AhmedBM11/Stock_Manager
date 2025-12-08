import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sat/logic/blocs/action_bloc/action_bloc.dart';

import 'package:sat/logic/blocs/product_bloc/product_bloc.dart';
import 'package:sat/logic/blocs/store_bloc/store_bloc.dart';
import 'package:sat/data/repositories/product_repository.dart';
import 'package:sat/data/repositories/action_repository.dart';
import 'package:sat/views/pages/page_one/welcome_page.dart';
//import 'package:sat/navigator/router_one.dart';
import 'app.dart';
import 'package:sat/logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:sat/logic/blocs/auth_bloc/auth_event.dart';
import 'package:sat/data/repositories/user_repository.dart';
import 'data/repositories/store_repository.dart';
import 'logic/change_notifiers/basket_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final productRepository = ProductRepository();
  final storeRepository = StoreRepository();
  final userRepository = UserRepository();
  /*final appRouter = AppRouter();*/

  runApp(
    ChangeNotifierProvider(
      create: (_) => BasketProvider(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
            AuthBloc(UserRepository())..add(CheckCurrentUserEvent()),
          ),
          BlocProvider(
            create: (context) => ProductBloc(productRepository),
          ),
          BlocProvider(
            create: (context) =>
                StoreBloc(storeRepository, userRepository),
          ),
          BlocProvider(
            create: (context) =>
            ActionBloc(ActionRepository()),
          ),
        ],
        child: App(/*appRouter: appRouter,*/),
      ),
    ),
  );
}
