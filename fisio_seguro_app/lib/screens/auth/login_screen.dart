// file fisio_seguro_app/lib/screens/auth/login_screen.dart

// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:fisio_seguro_app/reusable_widgets/reusable_widget.dart';
import 'package:fisio_seguro_app/screens/auth/register_screen.dart';
import 'package:fisio_seguro_app/screens/auth/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //controllers
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  //hide password
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradient(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.1, 20, 0),
            child: Column(
              children: [
                // Logo,
                //LogoWidget
                const LogoWidget(
                  imageName: 'assets/images/ivan_logo.png',
                ),
                const SizedBox(
                  height: 30,
                ),

                //Email Text Field
                ReusableTextField(
                  hintText: 'Enter your email', // Texto de sugerencia en el campo de texto
                  leadingIcon: Icons.email, // Icono que se mostrará antes del texto
                  isObscure: false, // Establecer en false ya que este es un campo de texto para el correo electrónico, no para una contraseña
                  controller: _emailTextController, // Controlador para el campo de texto
                ),
                const SizedBox(
                  height: 20,
                ),

                // Password Text Field
                TextField(
                  controller: _passwordTextController,
                  obscureText: _obscureText,
                  enableSuggestions: !_obscureText,
                  autocorrect: !_obscureText,
                  keyboardType: _obscureText ? TextInputType.visiblePassword : TextInputType.emailAddress,
                  decoration: getPasswordInputDecoration(_obscureText),
                ),
                // Forget Password button
                forgetPassword(context),
                // Login Button
                FirebaseUIButton(
                    title: "Login home",
                    onTap: () async {
                      context.push('/home');
                    }),
                signUpOption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?"),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ResetPassword())),
      ),
    );
  }

  InputDecoration getPasswordInputDecoration(bool obscureText) {
    return InputDecoration(
      prefixIcon: const Icon(
        Icons.lock_outline,
      ),
      suffixIcon: IconButton(
        icon: Icon(
          obscureText ? Icons.visibility : Icons.visibility_off,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
      hintText: "Enter Password",
      labelText: "Enter Password",
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
    );
  }
}
