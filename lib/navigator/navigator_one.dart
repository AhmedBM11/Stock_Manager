import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sat/data/repositories/user_repository.dart';

import 'package:sat/logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:sat/logic/blocs/auth_bloc/auth_event.dart';
import 'package:sat/logic/blocs/auth_bloc/auth_state.dart';
import 'package:sat/logic/blocs/store_bloc/store_bloc.dart';
import 'package:sat/logic/blocs/store_bloc/store_event.dart';
import 'package:sat/views/pages/page_one/auth_page.dart';
import 'package:sat/views/pages/page_two/home_page.dart';
import 'package:sat/views/pages/page_two/stores_page.dart';
import 'package:sat/views/pages/page_two/profile_page.dart';

import '../views/pages/page_one/welcome_page.dart';

class NavigatorOne extends StatefulWidget {
  NavigatorOne({super.key,});

  @override
  State<NavigatorOne> createState() => _NavigatorOneState();
}
class _NavigatorOneState extends State<NavigatorOne> {
  late List<Widget> _pages;
  final userRepository = UserRepository();
  dynamic userName = "user";

  @override
  void initState() {
    _buildPages();
    super.initState();
    if (FirebaseAuth.instance.currentUser!=null) {
      context.read<StoreBloc>().add(LoadStores(FirebaseAuth.instance.currentUser!.uid));
    }
  }

  void _buildPages() {
    _pages = [
      WelcomePage(isConnected: true, userName: userName),
      StoresPage(),
      ProfilePage(),
    ];
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _getUserName() async {
    final user = await userRepository.getCurrentUser();
    setState(() {
      userName = user?.name ?? "user";
      _buildPages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoadingState) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthenticatedState) {
          _getUserName();
          return Scaffold(
            appBar: AppBar(title: Text("Stock Manager"), actions: [IconButton(onPressed: () => context.read<AuthBloc>().add(LogoutEvent()), icon: Icon(Icons.logout))],),
            body: _pages[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: Colors.blueAccent,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(icon: Icon(Icons.store), label: "Stores",),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: "Me",),
              ],
            ),);
          /*AutoTabsScaffold(
              routes: [
                HomeRoute(),
                StoresRoute(),
                ProfileRoute(),
              ],
              bottomNavigationBuilder: (_, tabsRouter) {
                return BottomNavigationBar(
                  currentIndex: tabsRouter.activeIndex,
                  onTap: tabsRouter.setActiveIndex,
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home), label: "Home"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.store), label: "Stores"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person), label: "Me"),
                  ],
                );
              }
          );*/
        } else if (state is UnauthenticatedState) {
          return WelcomePage(isConnected: false,);
        } else if (state is AuthErrorState){return Text(state.message);}
        else {return Center(child: CircularProgressIndicator());}
      },
    );
  }
}
