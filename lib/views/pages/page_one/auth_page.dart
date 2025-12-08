import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sat/logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:sat/logic/blocs/auth_bloc/auth_event.dart';
import 'package:sat/logic/blocs/auth_bloc/auth_state.dart';
import 'package:sat/navigator/navigator_one.dart';

class AuthPage extends StatefulWidget {
  final bool? isLogin;
  const AuthPage({super.key, this.isLogin = false});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
  late bool isLogin;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    isLogin = widget.isLogin ?? false;
  }

  void _toggleForm() {
    setState(() => isLogin = !isLogin);
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (isLogin) {
        context.read<AuthBloc>().add(
          LoginEvent(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          ),
        );
      } else {
        context.read<AuthBloc>().add(
          RegisterEvent(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            name: _nameController.text.trim(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
                  snackBarAnimationStyle: AnimationStyle(duration: Duration(seconds: 1),),
            );
          }
          if (state is AuthenticatedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("Logging in ...")),
                snackBarAnimationStyle: AnimationStyle(duration: Duration(seconds: 1),)
            );
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return NavigatorOne();
            },));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Logged in ...")),
            );
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                child: Card(
                  key: ValueKey<bool>(isLogin),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isLogin ? "Welcome Back!" : "Create Account",
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          if (!isLogin)
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(labelText: "Full Name"),
                              validator: (value) => value!.isEmpty ? "Enter your name" : null,
                            ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(labelText: "Email"),
                            validator: (value) => value!.isEmpty ? "Enter a valid email" : null,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(labelText: "Password"),
                            obscureText: true,
                            validator: (value) => value!.length < 6 ? "Password too short" : null,
                          ),
                          const SizedBox(height: 25),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2193b0),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: Text(isLogin ? "Login" : "Register", style: const TextStyle(fontSize: 18)),
                          ),
                          const SizedBox(height: 15),
                          TextButton(
                            onPressed: _toggleForm,
                            child: Text(
                              isLogin ? "Don't have an account? Sign up" : "Already have an account? Login",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
