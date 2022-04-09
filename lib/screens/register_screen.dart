import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qureos_task1/app_cubit/app_cubit.dart';
import 'package:qureos_task1/core/cache_helper.dart';
import 'package:qureos_task1/core/functions.dart';
import 'package:qureos_task1/core/show_toast.dart';
import 'package:qureos_task1/Screens/home_page.dart';
import 'package:qureos_task1/network/end_points.dart';
import 'package:qureos_task1/register_cubit/register_cubit.dart';
import 'package:qureos_task1/register_cubit/register_state.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => RegisterCubit(),
        child: BlocConsumer<RegisterCubit, RegisterStates>(
          listener: (context, state) {
            var registerCubit = RegisterCubit.get(context);
            if (state is RegisterSuccessState) {
              if (state.loginModel.status == true) {
                showToast(
                    text: state.loginModel.message!,
                    state: ToastStates.SUCCESS);
                CacheHelper.saveData(
                        key: 'token', value: state.loginModel.data!.token!)
                    .then((value) {
                  token = state.loginModel.data!.token!;
                  AppCubit().getUserData();
                  navigateAndFinish(context, const HomePage());
                  registerCubit.nameController.clear();
                  registerCubit.emailController.clear();
                  registerCubit.phoneController.clear();
                  registerCubit.passwordController.clear();
                });
              } else //login_cubit state = false
              {
                showToast(
                    text: state.loginModel.message!, state: ToastStates.ERROR);
              }
            }
          },
          builder: (context, state) {
            var registerCubit = RegisterCubit.get(context);

            return SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: registerCubit.formKey,
                      child: Column(
                        children: [
                          const Text('Register',
                              style: TextStyle(
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)),
                          const SizedBox(height: 20.0),
                          const Text('Register now Don\'t waste your Time.',
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.grey)),
                          const SizedBox(height: 40.0),
                          TextFormField(
                            controller: registerCubit.nameController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "password is Empty";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Name',
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.red,
                                )),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: registerCubit.emailController,
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
                          const SizedBox(height: 10),
                          TextFormField(
                              controller: registerCubit.phoneController,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Phone is Empty";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Phone Number',
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    color: Colors.red,
                                  ))),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: registerCubit.passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: registerCubit.isPassword,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password is  empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: 'Password',
                              prefixIcon:
                                  const Icon(Icons.lock, color: Colors.red),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  registerCubit.suffix,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  registerCubit.changePasswordVisibility();
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ConditionalBuilder(
                            condition: state is! RegisterLoadingState,
                            builder: (context) => Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.red),
                              child: MaterialButton(
                                child: const Text(
                                  'Register',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  if (registerCubit.formKey.currentState!
                                      .validate()) {
                                    registerCubit.userRegister(
                                        name: registerCubit.nameController.text,
                                        email:
                                            registerCubit.emailController.text,
                                        phone:
                                            registerCubit.phoneController.text,
                                        password: registerCubit
                                            .passwordController.text);
                                  }
                                },
                              ),
                            ),
                            fallback: (context) => const Center(
                                child: CircularProgressIndicator()),
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
      ),
    );
  }
}
