import 'package:e_hrm/screens/auth/login/widget/form_login.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscureText = true;
  void ontoggle() => setState(() => _obscureText = !_obscureText);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome")),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'lib/assets/image/oss_icon.png',
                width: 280,
                fit: BoxFit.contain,
              ),
              FormLogin(
                emailController: emailController,
                passwordController: passwordController,
                obscureText: _obscureText,
                onToggle: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                formKey: formKey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
