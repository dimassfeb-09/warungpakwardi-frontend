import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warungpakwardi/constant/color.dart';
import 'package:warungpakwardi/models/Register.dart';
import 'package:warungpakwardi/widgets/ButtonCustom.dart';
import 'package:warungpakwardi/widgets/SnacbarCustom.dart';
import 'package:warungpakwardi/widgets/TextButtonCustom.dart';
import 'package:warungpakwardi/widgets/TextFieldCustom.dart';

import '../blocs/register/register_bloc.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
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
                        "Selamat Datang",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Daftar untuk mulai mengelola toko Anda",
                        style: GoogleFonts.poppins(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                TextFieldCustom(
                  controller: nameController,
                  title: 'Nama Lengkap',
                  hintText: 'Masukkan nama lengkap',
                  textInputType: TextFieldType.email,
                ),
                TextFieldCustom(
                  controller: emailController,
                  title: 'Email',
                  hintText: 'Masukkan email',
                  textInputType: TextFieldType.email,
                ),
                TextFieldCustom(
                  controller: passwordController,
                  title: 'Password',
                  hintText: 'Masukkan Kata Sandi',
                  textInputType: TextFieldType.password,
                ),
                BlocConsumer<RegisterBloc, RegisterState>(
                  listener: (context, state) {
                    if (state is RegisterErrorState) {
                      SnackbarCustom.show(
                        context,
                        message: state.message,
                        status: SnackbarStatusType.error,
                        type: SnackbarType.normal,
                      );
                      return;
                    }

                    if (state is RegisterLoadedState) {
                      Navigator.pop(context);
                    }
                  },
                  builder: (context, state) {
                    String buttonName = 'Daftar';

                    if (state is RegisterLoadingState) {
                      buttonName = 'Loading...';
                    }

                    return ButtonCustom(
                      name: buttonName,
                      onClick: () {
                        Register register = Register(
                          name: nameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                        );
                        context.read<RegisterBloc>().add(
                          RegisterSubmitEvent(register: register),
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
                      Text("Sudah punya akun?"),
                      TextButtonCustom(
                        text: 'Login ',
                        onClick: () => Navigator.pop(context),
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
