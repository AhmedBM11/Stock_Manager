import 'package:auto_route/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sat/data/models/store_model.dart';
import 'package:sat/logic/blocs/store_bloc/store_event.dart';
import 'package:sat/logic/blocs/store_bloc/store_bloc.dart';
import 'package:sat/logic/blocs/store_bloc/store_state.dart';
import 'package:sat/views/widgets/store_container.dart';
import 'package:sat/views/pages/page_four/add_store_page.dart';

//@RoutePage()
class StoresPage extends StatelessWidget {
  const StoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<StoreBloc, StoreState>(
        builder: (context, state) {
          if (state is StoreLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StoreLoaded) {
            final stores = state.stores;
            if (stores.isEmpty) {
              return const Center(
                child: Text(
                  "No stores yet.\nClick + to add one!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }
            return AnimatedListWidget(stores: stores);
          } else {
            return const Center(
              child: Text("Something went wrong!"),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "add_store_btn",
        onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AddStorePage();
        },));
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}

class AnimatedListWidget extends StatelessWidget {
  final List<StoreModel> stores;

  const AnimatedListWidget({super.key, required this.stores});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: stores.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final store = stores[index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 300 + (index * 100)),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, (1 - value) * 20),
                child: child,
              ),
            );
          },
          child: StoreCard(store: store),
        );
      },
    );
  }
}
