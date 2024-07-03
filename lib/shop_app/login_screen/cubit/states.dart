import 'package:news_app/models/shop_app/login_model.dart';

abstract class ShopLoginStates {}

class ShopLoginInInitialState extends ShopLoginStates{}
class ShopLoginInLoadingState extends ShopLoginStates{}
class ShopLoginInSuccessState extends ShopLoginStates
{
  final ShopLoginModel loginModel;

  ShopLoginInSuccessState(this.loginModel);
}
class ShopLoginInErrorState extends ShopLoginStates
{
  final String error;
  ShopLoginInErrorState(this.error);
}

class ShopLoginEyePassword extends ShopLoginStates{}
