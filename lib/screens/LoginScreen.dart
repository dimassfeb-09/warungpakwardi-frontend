import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warungpakwardi/constant/color.dart';
import 'package:warungpakwardi/widgets/ButtonCustom.dart';
import 'package:warungpakwardi/widgets/SnacbarCustom.dart';
import 'package:warungpakwardi/widgets/TextButtonCustom.dart';
import 'package:warungpakwardi/widgets/TextFieldCustom.dart';

import '../blocs/login/bloc/login_bloc.dart';
import '../models/Login.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              spacing: 20,
              children: [
                SizedBox(height: 35),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/icon.svg"),
                      const SizedBox(height: 24),
                      Text(
                        "Warung Pak Wardi",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Masuk ke akun Anda untuk melanjutkan",
                        style: GoogleFonts.poppins(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                TextFieldCustom(
                  controller: emailController,
                  title: 'Email',
                  hintText: 'Masukkan email',
                  textInputType: TextFieldType.email,
                  colorField: kGreyDarkColor.withAlpha(20),
                ),
                TextFieldCustom(
                  controller: passwordController,
                  title: 'Password',
                  hintText: 'Masukkan Kata Sandi',
                  textInputType: TextFieldType.password,
                  colorField: kGreyDarkColor.withAlpha(20),
                ),
                BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is LoginErrorState) {
                      SnackbarCustom.show(
                        context,
                        message: state.message,
                        status: SnackbarStatusType.error,
                        type: SnackbarType.normal,
                      );
                      return;
                    }

                    if (state is LoginLoadedState) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home-screen',
                        (route) => false,
                      );
                    }
                  },
                  builder: (context, state) {
                    String buttonName = 'Login';

                    if (state is LoginLoadingState) {
                      buttonName = 'Loading...';
                    }

                    return ButtonCustom(
                      name: buttonName,
                      onClick: () {
                        Login login = Login(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                        context.read<LoginBloc>().add(
                          LoginSubmitEvent(login: login),
                        );
                      },
                    );
                  },
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 5,
                    children: [
                      Text("Belum punya akun?"),
                      TextButtonCustom(
                        text: 'Daftar ',
                        onClick:
                            () => Navigator.pushNamed(
                              context,
                              '/register-screen',
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
