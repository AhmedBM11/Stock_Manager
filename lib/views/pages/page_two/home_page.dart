import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

import 'package:sat/data/models/user_model.dart';
import 'package:sat/data/repositories/user_repository.dart';

//@RoutePage()
class HomePage extends StatelessWidget {
  final UserRepository userRepository = UserRepository();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<UserModel?>(
        future: userRepository.getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading user"));
          } else {
            final userName = snapshot.data!.name;
            return Center(
              child: Text(
                "Welcome, $userName!",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
