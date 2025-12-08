import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sat/logic/blocs/store_bloc/store_bloc.dart';

import 'package:sat/navigator/navigator_two.dart';
import 'package:sat/data/models/store_model.dart';
import 'package:sat/views/widgets/store_auth_container.dart' show StorePasswordDialog;

class StoreCard extends StatelessWidget {
  final StoreModel store;

  const StoreCard({
    super.key,
    required this.store,
  });

  Color _getBorderColor(int access) {
    switch (access) {
      case 3:
        return Colors.blue; // Full admin
      case 2:
        return Colors.green; // Read & Write
      case 1:
        return Colors.red; // Read only
      default:
        return Colors.black; // No access
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: _getBorderColor(store.accessibility),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        //onLongPress: ,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          store.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          onPressed: () {

              showDialog(
              context: context,builder: (_) => BlocProvider.value(
              value: context.read<StoreBloc>(),
              child: StorePasswordDialog(
                store: store,
              ),
              ),
              );
              },
        ),
          onLongPress: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue, size: 30),
                        onPressed: () {
                          Navigator.pop(context);
                          },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red, size: 30),
                        onPressed: () {
                          Navigator.pop(context);
                          },
                      ),
                    ],
                  ),
                );
                },
          );
          },
      )
    );
  }
}
