import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/models/shop_app/login_model.dart';
import 'package:news_app/network/end_points.dart';
import 'package:news_app/network/remote/dio_helper.dart';
import 'package:news_app/shop_app/login_screen/cubit/states.dart';
import 'package:news_app/shop_app/register/cubit/states.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates>
{
  ShopRegisterCubit() : super(ShopRegisterInitialState());


  static ShopRegisterCubit get(context) => BlocProvider.of(context);

  ShopLoginModel? loginModel;

  void userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
})
  {
    emit(ShopRegisterLoadingState());
    DioHelper.postData(
      url: REGISTER,
      data: {
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
      },
    ).then((value)
    {
      print(value.toString());
      loginModel = ShopLoginModel.fromJson(value?.data);
      emit(ShopRegisterSuccessState(loginModel!));
    }
    ).catchError((error)
    {
      emit(ShopRegisterErrorState(error.toString()));
    });
  }

  IconData suffix =Icons.visibility_outlined;
  bool isPassword =  true;

  void changeEye()
  {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_off_outlined :Icons.visibility_outlined;
    emit(ShopRegisterEyePassword());
  }
}