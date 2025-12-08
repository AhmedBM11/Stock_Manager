import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sat/logic/blocs/store_bloc/store_bloc.dart';
import 'package:sat/logic/blocs/store_bloc/store_event.dart';
import 'package:sat/navigator/navigator_one.dart';

import 'package:sat/views/pages/page_three/basket_page.dart';
import 'package:sat/views/pages/page_three/products_page.dart';
import 'package:sat/views/pages/page_three/admin_page.dart';
import 'package:sat/views/pages/page_two/stores_page.dart';

class NavigatorTwo extends StatefulWidget {
  final String storeId;
  final int accessibility;
  const NavigatorTwo({super.key,required this.storeId,required this.accessibility});

  @override
  State<NavigatorTwo> createState() => _NavigatorTwoState();

}

class _NavigatorTwoState extends State<NavigatorTwo> {
  late List<List> _pages;

  @override
  void initState() {
    super.initState();

    if (widget.accessibility == 3) {
     _pages = [
       [AdminPage(storeId: widget.storeId, accessibility: widget.accessibility,),"Admin Page"],
       [ProductsPage(storeId: widget.storeId, accessibility: widget.accessibility,),"Products Page"],
       [BasketPage(storeId: widget.storeId,),"Basket Page"],
    ];
    } else {
      _pages = [
        [ProductsPage(storeId: widget.storeId, accessibility: widget.accessibility,),"Products Page"],
        [BasketPage(storeId: widget.storeId,),"Basket Page"]
      ];
    }
  }
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.keyboard_backspace), onPressed: () {
          context.read<StoreBloc>().add(LoadStores(FirebaseAuth.instance.currentUser!.uid));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NavigatorOne(),));
        },),
        title: Text(
          _pages[_selectedIndex][1],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: _pages[_selectedIndex][0],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent,

        items: widget.accessibility==3? const [
          BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: 'Admin',),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Products',),
          BottomNavigationBarItem(icon: Icon(Icons.shopify), label: 'Basket',),
        ]:const [
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Products',),
          BottomNavigationBarItem(icon: Icon(Icons.shopify), label: 'Basket',),
        ],
      ),
    );
  }
}
