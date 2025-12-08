import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sat/logic/blocs/action_bloc/action_bloc.dart';
import 'package:sat/logic/blocs/action_bloc/action_event.dart';
import 'package:sat/views/pages/page_four/user_details_page.dart';

import 'package:sat/views/widgets/user_container.dart';
import 'package:sat/views/widgets/add_user_container.dart';
import 'package:sat/logic/blocs/store_bloc/store_bloc.dart';
import 'package:sat/logic/blocs/store_bloc/store_event.dart';
import 'package:sat/logic/blocs/store_bloc/store_state.dart';


class AdminPage extends StatefulWidget {
  final String storeId;
  final int accessibility;

  const AdminPage({super.key, required this.storeId, required this.accessibility});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int currentIndex = 0;
  bool isEditing = false;
  final accessibilityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<StoreBloc>().add(GetStoreUsersEvent(storeId: widget.storeId));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.accessibility != 3) {
      return const Scaffold(body: Center(child: Text("You are not an admin")));
    }

    return Scaffold(
      body: BlocBuilder<StoreBloc, StoreState>(
        builder: (context, state) {
          if (state is StoreUsersLoaded) {
            final users = state.users;
            if (users.isEmpty) return const Center(child: Text("No users"));
            if (currentIndex >= users.length) {
              currentIndex = users.length - 1;
            }
            final user = users[currentIndex];
            accessibilityController.text = user["accessibility"].toString();

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UserContainer(
                  avatarUrl: user["avatarUrl"] ?? "https://img.freepik.com/vecteurs-libre/cercle-utilisateurs-defini_78370-4704.jpg?semt=ais_hybrid&w=740&q=80",
                  email: user['email'],
                  userName: user["name"],
                  accessibility: user["accessibility"].toString(),
                  isEditing: isEditing,
                  accessibilityController: accessibilityController,
                  onPrev: () {
                    setState(() {
                      currentIndex = (currentIndex - 1 + users.length) % users.length;
                    });
                  },
                  onNext: () {
                    setState(() {
                      currentIndex = (currentIndex + 1) % users.length;
                    });
                  },
                  onSeeDetails: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetailsPage(userId: user['id'], storeId: widget.storeId,),));
                  },
                  onEdit: () async {
                    if (isEditing) {
                      context.read<StoreBloc>().add(UpdateUserAccessibilityEvent(
                        storeId: widget.storeId,
                        userId: user['id'],
                        accessibility: int.parse(accessibilityController.text),
                      ));
                    }
                    setState(() => isEditing = !isEditing);
                  },
                  onDelete: () {
                    if (isEditing) {
                      setState(() => isEditing = false);
                    } else {
                      context.read<StoreBloc>().add(DeleteStoreUserEvent(userId: user['id'],storeId: widget.storeId));
                    }
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AddUserContainer(
                        onSave: (email, access) {
                          context.read<StoreBloc>().add(AddStoreUserEvent(
                            storeId: widget.storeId,
                            mail: email,
                            accessibility: int.parse(access),
                          ));
                        },
                      ),
                    );
                  },
                  child: const Text("Add User"),
                ),
              ],
            );
          }

          if (state is StoreLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return const Center(child: Text("Error loading users"));
        },
      ),
    );
  }
}
