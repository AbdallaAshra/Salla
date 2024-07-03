import 'package:flutter/material.dart';
import 'package:news_app/layout/shop_app/shop_layout.dart';
import 'package:news_app/network/local/cache_helper.dart';
import 'package:news_app/shared/components.dart';
import 'package:news_app/shared/constants.dart';
import 'package:news_app/shop_app/login_screen/cubit/cubit.dart';
import 'package:news_app/shop_app/login_screen/cubit/states.dart';
import 'package:news_app/shop_app/register/shop_register_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ShopLoginScreen extends StatelessWidget {

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit , ShopLoginStates>(
        listener: (BuildContext context, state)
        {
          if(state is ShopLoginInSuccessState)
          {
            if(state.loginModel.status!)
            {
              print(state.loginModel.message);
              print(state.loginModel.data?.token);

              CacheHelper.saveData(key: 'token', value: state.loginModel.data?.token).then((value)
              {
                token = state.loginModel.data?.token;
                navigateAndFinish(context, ShopLayout());
              });
            }else {
              print(state.loginModel.message);

              showToast(
                text: state.loginModel.message.toString(),
                state: ToastStates.ERROR,
              );
            }
          }
        },
        builder: (BuildContext context, Object? state)
        {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40.0,
                          ),
                        ),
                        Text(
                          'login now to browse our hot offers',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        defaultTFF(
                          controller: emailController,
                          prefixIcon: Icon(Icons.email_outlined,),
                          textInputType: TextInputType.emailAddress,
                          label: 'Email Address',
                          validate: (String? value)
                          {
                            if(value!.isEmpty)
                            {
                              return 'please enter your email address';
                            }
                          },
                          obscureText: false,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        defaultTFF(
                          controller: passwordController,
                          onSubmit: (value)
                          {
                            if(formKey.currentState!.validate())
                            {
                              ShopLoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          prefixIcon: Icon(Icons.lock_outline,),
                          textInputType: TextInputType.visiblePassword,
                          label: 'password',
                          validate: (String? value)
                          {
                            if(value!.isEmpty)
                            {
                              return 'password is too short';
                            }
                          },
                          suffixPressed: (){
                            ShopLoginCubit.get(context).changeEye();
                          },
                          suffixIcon: ShopLoginCubit.get(context).suffix,
                          obscureText: ShopLoginCubit.get(context).isPassword,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopLoginInLoadingState,
                          builder: (BuildContext context) { return defaultButton(
                            text: "Login",
                            function: (){
                              if(formKey.currentState!.validate())
                              {
                                ShopLoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                          ); },
                          fallback: (BuildContext context) => Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: [
                            Text(
                              'Don\'t have an account?',
                            ),
                            defaultTextButton(
                              text: 'Register Now',
                              function: (){
                                navigateTo(context, ShopRegisterScreen());
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
