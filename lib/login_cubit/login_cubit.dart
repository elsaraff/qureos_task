import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qureos_task1/core/dio_helper.dart';
import 'package:qureos_task1/login_cubit/login_states.dart';
import 'package:qureos_task1/models/login_model.dart';
import 'package:qureos_task1/network/end_points.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    suffix =
        isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;
    isPassword = !isPassword;
    emit(ChangePasswordVisibilityState());
  }

  UserModel? loginModel;

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());
    DioHelper.postData(
      url: LOGIN,
      data: {
        'email': email,
        'password': password,
      },
    ).then((value) {
      loginModel = UserModel.fromJson(value.data);
      emit(LoginSuccessState(loginModel!));
    }).catchError((error) {
      debugPrint(error.toString());
      emit(LoginErrorState(error.toString()));
    });
  }
}
