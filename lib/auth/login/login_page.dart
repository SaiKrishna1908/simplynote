import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplynote/app_color.dart';
import 'package:simplynote/auth/login/cubit/login_cubit.dart';
import 'package:simplynote/main.dart';

class LoginInView extends StatefulWidget {
  const LoginInView({super.key});

  @override
  State<LoginInView> createState() => _LoginInViewState();
}

class _LoginInViewState extends State<LoginInView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> _showAlertDialog(
      BuildContext context, String errorMessage) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('An Error Occured'),
        content: Text(errorMessage),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Close'),
            onPressed: () async {
              goRouter.pop();
            },
          ),
        ],
      ),
    );
  }

  bool isSignIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (ctx, state) async {
          if (state is LoginError) {
            _showAlertDialog(
              context,
              state.errorMessage,
            );
            context.read<LoginCubit>().tryLogin();
          }
          if (state is LoginSuccess) {
            goRouter.go('/home');
          }
        },
        builder: (context, state) {
          if (state is LoginInitial || state is LoginError) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ListView(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Notes',
                      style: TextStyle(
                        color: AppColor.lighten(AppColor.appPrimaryColor),
                        fontWeight: FontWeight.w900,
                        fontSize: 50,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'ButterMilk',
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      isSignIn ? 'Sign in' : 'Create Account',
                      style: const TextStyle(
                        fontSize: 20,
                        color: AppColor.appPrimaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColor.appSecondaryColor),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColor.appPrimaryColor),
                        ),
                        labelText: 'Username',
                        labelStyle: TextStyle(
                          color: AppColor.lighten(
                            AppColor.appPrimaryColor,
                            0.4,
                          ),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColor.appSecondaryColor),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.appPrimaryColor),
                      ),
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: AppColor.lighten(AppColor.appPrimaryColor, 0.4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(AppColor.appPrimaryColor),
                      ),
                      onPressed: () async {
                        if (isSignIn) {
                          await context.read<LoginCubit>().signIn(
                              nameController.text, passwordController.text);
                        } else {
                          await context
                              .read<LoginCubit>()
                              .createUserWithEmailAndPassword(
                                  nameController.text, passwordController.text);
                        }
                      },
                      child: Text(
                        isSignIn ? 'Login' : 'Create Account',
                        style: const TextStyle(
                          color: AppColor.appAccentColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () => setState(() {
                      isSignIn = !isSignIn;
                    }),
                    child: Text(
                      isSignIn ? 'Create Account' : 'Sign In',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // Row(
                  //   children: <Widget>[
                  //     const Text('Does not have account?'),
                  //     TextButton(
                  //       child: const Text(
                  //         'Sign in',
                  //         style: TextStyle(fontSize: 20),
                  //       ),
                  //       onPressed: () {
                  //         //signup screen
                  //       },
                  //     )
                  //   ],
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  // ),
                ],
              ),
            );
          } else if (state is LoginLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.appPrimaryColor,
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
