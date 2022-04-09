import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qureos_task1/Screens/login_screen.dart';
import 'package:qureos_task1/app_cubit/app_cubit.dart';
import 'package:qureos_task1/core/cache_helper.dart';
import 'package:qureos_task1/core/dio_helper.dart';
import 'package:qureos_task1/screens/home_page.dart';
import 'package:qureos_task1/network/end_points.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CacheHelper.init();
  DioHelper.init();

  token = CacheHelper.getData(key: 'token');

  debugPrint(token.toString());

  Widget startWidget;

  if (token == '') {
    startWidget = const LoginScreen();
  } else {
    startWidget = const HomePage();
  }

  runApp(MyApp(
    startWidget: startWidget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget? startWidget;

  const MyApp({Key? key, this.startWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..getUserData(),
      child: MaterialApp(
        title: 'Qureos App',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        debugShowCheckedModeBanner: false,
        home: startWidget,
      ),
    );
  }
}
