import 'package:qureos_task1/models/login_model.dart';

abstract class AppStates {}

class AppInitialState extends AppStates {}

class SuccessUserDataState extends AppStates {
  final UserModel loginModel;

  SuccessUserDataState(this.loginModel);
}

class ErrorUserDataState extends AppStates {}
