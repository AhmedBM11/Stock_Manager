import 'package:flutter/material.dart';

class AddUserContainer extends StatefulWidget {
  final Function(String email, String accessibility) onSave;

  const AddUserContainer({super.key, required this.onSave});

  @override
  State<AddUserContainer> createState() => _AddUserContainerState();
}

class _AddUserContainerState extends State<AddUserContainer> {
  final _emailController = TextEditingController();
  final _accessibilityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add User"),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: "Email"),
          ),
          TextField(
            controller: _accessibilityController,
            decoration: const InputDecoration(labelText: "Accessibility"),
          ),
          SizedBox(height: 12,),
          Text("Notice that the user will be added to the store only if the email corresponds to a registered user.",style: TextStyle(color: Colors.blue, fontSize: 12), )
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () {
            widget.onSave(_emailController.text, _accessibilityController.text);
            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],

    );
  }
}
