import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qureos_task1/app_cubit/app_cubit.dart';
import 'package:qureos_task1/app_cubit/app_states.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var appCubit = AppCubit.get(context);

          if (appCubit.userModel == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Center(
              child: RichText(
                text: TextSpan(
                    text: 'welcome ',
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(
                          text: appCubit.userModel!.data!.email.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ]),
              ),
            );
          }
        },
      ),
    );
  }
}
