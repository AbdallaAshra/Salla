import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/models/shop_app/login_model.dart';
import 'package:news_app/network/end_points.dart';
import 'package:news_app/network/remote/dio_helper.dart';
import 'package:news_app/shop_app/login_screen/cubit/states.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates>
{
  ShopLoginCubit() : super(ShopLoginInInitialState());


  static ShopLoginCubit get(context) => BlocProvider.of(context);

  ShopLoginModel? loginModel;

  void userLogin({
    required String email,
    required String password,
})
  {
    emit(ShopLoginInLoadingState());
    DioHelper.postData(
      url: LOGIN,
      data: {
        'email': email,
        'password': password,
      },
    ).then((value)
    {
      print(value.toString());
      loginModel = ShopLoginModel.fromJson(value?.data);
      emit(ShopLoginInSuccessState(loginModel!));
    }
    ).catchError((error)
    {
      emit(ShopLoginInErrorState(error.toString()));
    });
  }

  IconData suffix =Icons.visibility_outlined;
  bool isPassword =  true;

  void changeEye()
  {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_off_outlined :Icons.visibility_outlined;
    emit(ShopLoginEyePassword());
  }
}