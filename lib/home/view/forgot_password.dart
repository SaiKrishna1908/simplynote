import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simplynote/app_color.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  static const routeName = '/forgot-password';

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final firstNewPasswordController = TextEditingController();
  final secondNewPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'Your Email',
                    hintStyle: TextStyle(
                      color: AppColor.appAccentColor,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor.appPrimaryColor,
                      ),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance.sendPasswordResetEmail(
                        email: emailController.text,
                      );
                      if (!mounted) {
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: AppColor.appPrimaryColor,
                          content: Text(
                            'Reset password sent',
                            style: TextStyle(color: AppColor.appAccentColor),
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Send OTP',
                      style: TextStyle(
                        color: AppColor.appAccentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
