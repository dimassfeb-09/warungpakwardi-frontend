import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/bloc/auth_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is UserAuthenticated) {
            Navigator.pushReplacementNamed(context, '/home-screen');
          } else if (state is UserUnauthenticated) {
            Navigator.pushReplacementNamed(context, '/login-screen');
          } else if (state is UserAuthenticatedErrorState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            Navigator.pushReplacementNamed(context, '/login-screen');
          }
        },
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
