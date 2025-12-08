import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sat/data/models/store_model.dart';
import 'package:sat/logic/blocs/store_bloc/store_bloc.dart';
import 'package:sat/logic/blocs/store_bloc/store_event.dart';
import 'package:sat/logic/blocs/store_bloc/store_state.dart';
import 'package:sat/navigator/navigator_two.dart';

class StorePasswordDialog extends StatefulWidget {
  final StoreModel store;

  const StorePasswordDialog({
    Key? key,
    required this.store,
  }) : super(key: key);

  @override
  _StorePasswordDialogState createState() => _StorePasswordDialogState();
}

class _StorePasswordDialogState extends State<StorePasswordDialog> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreBloc, StoreState>(
      listener: (context, state) {
        if (state is StorePasswordSuccess) {
          // ✅ password correct → go to store page
          Navigator.pop(context); // close dialog
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NavigatorTwo(storeId: state.store.id,accessibility:state.store.accessibility,),
            ),
          );
        } else if (state is StorePasswordFailure) {
          // ❌ wrong password → show message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return AlertDialog(
          title: Text("Enter password for ${widget.store.name}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                ),
              ),
              if (state is StorePasswordChecking)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Enter Store"),
              onPressed: () {
                final password = _passwordController.text.trim();
                context.read<StoreBloc>().add(
                  VerifyStorePasswordEvent(
                    store: widget.store,
                    password: password,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
