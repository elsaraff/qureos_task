import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qureos_task1/app_cubit/app_states.dart';
import 'package:qureos_task1/core/dio_helper.dart';
import 'package:qureos_task1/models/login_model.dart';
import 'package:qureos_task1/network/end_points.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;
  void getUserData() {
    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      userModel = UserModel.fromJson(value.data);
      emit(SuccessUserDataState(userModel!));
    }).catchError((error) {
      debugPrint(error.toString());
      emit(ErrorUserDataState());
    });
  }
}
