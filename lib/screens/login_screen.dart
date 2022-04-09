import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qureos_task1/app_cubit/app_cubit.dart';
import 'package:qureos_task1/core/cache_helper.dart';
import 'package:qureos_task1/core/functions.dart';
import 'package:qureos_task1/core/show_toast.dart';
import 'package:qureos_task1/login_cubit/login_cubit.dart';
import 'package:qureos_task1/login_cubit/login_states.dart';
import 'package:qureos_task1/screens/home_page.dart';
import 'package:qureos_task1/network/end_points.dart';
import 'package:qureos_task1/screens/register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          var loginCubit = LoginCubit.get(context);
          if (state is LoginSuccessState) {
            if (state.loginModel.status == true) {
              showToast(
                  text: state.loginModel.message!, state: ToastStates.SUCCESS);
              CacheHelper.saveData(
                      key: 'token', value: state.loginModel.data!.token)
                  .then((value) {
                token = state.loginModel.data!.token!;
                AppCubit().getUserData();
                navigateAndFinish(context, const HomePage());
                loginCubit.passwordController.clear();
              });
            } else //login_cubit state = false
            {
              showToast(
                  text: state.loginModel.message!, state: ToastStates.ERROR);
            }
          }
        },
        builder: (context, state) {
          var loginCubit = LoginCubit.get(context);
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: loginCubit.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Login',
                            style: TextStyle(
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                        const SizedBox(height: 20.0),
                        const Text('Login now to browse our hot offers.',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.grey)),
                        const SizedBox(height: 60.0),
                        TextFormField(
                          controller: loginCubit.emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Email is Empty";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Email Address',
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Colors.red,
                              )),
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: loginCubit.passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: loginCubit.isPassword,
                          onFieldSubmitted: (value) {
                            if (loginCubit.formKey.currentState!.validate()) {
                              loginCubit.userLogin(
                                  email: loginCubit.emailController.text,
                                  password: loginCubit.passwordController.text);
                              loginCubit.passwordController.clear();
                            }
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "password is Empty";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'Password',
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.red,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                loginCubit.suffix,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                loginCubit.changePasswordVisibility();
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        ConditionalBuilder(
                            condition: state is! LoginLoadingState,
                            builder: (context) => Container(
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10)),
                                  width: double.infinity,
                                  child: MaterialButton(
                                    onPressed: () {
                                      if (loginCubit.formKey.currentState!
                                          .validate()) {
                                        loginCubit.userLogin(
                                            email:
                                                loginCubit.emailController.text,
                                            password: loginCubit
                                                .passwordController.text);
                                      }
                                    },
                                    child: const Text(
                                      'LOGIN',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25.0,
                                      ),
                                    ),
                                  ),
                                ),
                            fallback: (context) => const Center(
                                child: CircularProgressIndicator())),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have account ?',
                              style: TextStyle(fontSize: 20),
                            ),
                            TextButton(
                                onPressed: () {
                                  navigateTo(context, const RegisterScreen());
                                },
                                child: const Text(
                                  'Register',
                                  style: TextStyle(
                                      fontSize: 20,
                                      decoration: TextDecoration.underline),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
