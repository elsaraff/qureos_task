import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qureos_task1/core/dio_helper.dart';
import 'package:qureos_task1/models/login_model.dart';
import 'package:qureos_task1/network/end_points.dart';
import 'package:qureos_task1/register_cubit/register_state.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(RegisterChangePasswordVisibilityState());
  }

  //===================================================================================

  UserModel? loginModel;

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    emit(RegisterLoadingState());

    DioHelper.postData(
      url: REGISTER,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      },
    ).then((value) {
      loginModel = UserModel.fromJson(value.data);
      emit(RegisterSuccessState(loginModel!));
    }).catchError((error) {
      emit(RegisterErrorState(error.toString()));
    });
  }
}
