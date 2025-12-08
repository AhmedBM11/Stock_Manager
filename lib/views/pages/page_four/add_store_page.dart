import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import 'package:sat/logic/blocs/store_bloc/store_bloc.dart';
import 'package:sat/logic/blocs/store_bloc/store_event.dart';
import 'package:sat/data/models/store_model.dart';
import 'package:sat/data/repositories/user_repository.dart';

class AddStorePage extends StatefulWidget {
  const AddStorePage({super.key});

  @override
  State<AddStorePage> createState() => _AddStorePageState();
}

class _AddStorePageState extends State<AddStorePage> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<int> accessibilityNotifier = ValueNotifier<int>(2); // default read & write
  final List<Map<String, dynamic>> users = [];

  void _addUserField() {
    setState(() {
      users.add({
        "email": TextEditingController(),
        "access": 0,
      });
    });
  }

  void _deleteUserField(index) {
    setState(() {
      users.remove(users[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'add_store_page',
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Store"),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          actions: [
            IconButton(
              icon: const Icon(Icons.save, size: 28),
              onPressed: () async {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Store name cannot be empty!")),
                  );
                  return;
                }

                final newStore = StoreModel(
                  id: const Uuid().v4(),
                  name: nameController.text.trim(),
                  password: passwordController.text.trim().isEmpty
                      ? "123456"
                      : passwordController.text.trim(),
                  accessibility: accessibilityNotifier.value,
                );
                final UserRepository userRepository = UserRepository();
                final user = await userRepository.getCurrentUser();
                context.read<StoreBloc>().add(AddStoreEvent(store: newStore,userId: user!.id, accessibility: 3));
                for (var user in users) {
                  final email = user["email"].text.trim();   // TextEditingController
                  final access = user["access"];             // int accessibility

                  if (email.isNotEmpty) {
                    context.read<StoreBloc>().add(
                      AddStoreUserEvent(
                        storeId: newStore.id,
                        mail: email,
                        accessibility: access,
                      ),
                    );
                  }
                }
                Navigator.pop(context);
              },
            )
          ],
        ),
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 4000),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "Store Information",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Store Name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password (optional)",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),

              SizedBox(
                height: 350,
                child: ListView.separated(
                  itemCount: users.length,
                  separatorBuilder: (_, __) => const Divider(thickness: 1),
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text(
                          "User ${index + 1}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blueAccent,
                          ),
                        ),
                          SizedBox(width: 275,),
                          IconButton(onPressed: () => _deleteUserField(index), icon: Icon(Icons.cancel),)
                        ],),
                        const SizedBox(height: 10),
                        TextField(
                          controller: users[index]["email"],
                          decoration: InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 15),
                        DropdownButtonFormField<int>(
                          value: users[index]["access"],
                          decoration: InputDecoration(
                            labelText: "Accessibility",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          items: const [
                            DropdownMenuItem(value: 0, child: Text("No Access")),
                            DropdownMenuItem(value: 1, child: Text("Read Only")),
                            DropdownMenuItem(value: 2, child: Text("Read & Write")),
                            DropdownMenuItem(value: 3, child: Text("Admin")),
                          ],
                          onChanged: (val) {
                            setState(() {
                              users[index]["access"] = val!;
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _addUserField,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 5000),
                  curve: Curves.easeInOutBack,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add_business_outlined,
                      size: 80, color: Colors.blueAccent),
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }
}
