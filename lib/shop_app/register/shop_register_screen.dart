import 'package:flutter/material.dart';
import 'package:news_app/layout/shop_app/shop_layout.dart';
import 'package:news_app/network/local/cache_helper.dart';
import 'package:news_app/shared/components.dart';
import 'package:news_app/shared/constants.dart';
import 'package:news_app/shop_app/login_screen/cubit/cubit.dart';
import 'package:news_app/shop_app/login_screen/cubit/states.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/shop_app/register/cubit/cubit.dart';
import 'package:news_app/shop_app/register/cubit/states.dart';

class ShopRegisterScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
        listener: (BuildContext context, ShopRegisterStates state)
        {
          if(state is ShopRegisterSuccessState)
          {
            if(state.loginModel.status!)
            {

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
        builder: (BuildContext context, ShopRegisterStates state)
        {
          return Scaffold(
            appBar: AppBar(),
            body : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REGISTRE',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40.0,
                          ),
                        ),
                        Text(
                          'Register now to browse our hot offers',
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
                          controller: nameController,
                          prefixIcon: Icon(Icons.person,),
                          textInputType: TextInputType.name,
                          label: 'User Name',
                          validate: (String? value)
                          {
                            if(value!.isEmpty)
                            {
                              return 'please enter your User Name';
                            }
                          },
                          obscureText: false,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        defaultTFF(
                          controller: emailController,
                          prefixIcon: Icon(Icons.email,),
                          textInputType: TextInputType.emailAddress,
                          label: 'Email Address',
                          validate: (String? value)
                          {
                            if(value!.isEmpty)
                            {
                              return 'please enter your User Email Address';
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
                              ShopRegisterCubit.get(context).userRegister(
                                email: emailController.text,
                                password: passwordController.text,
                                name: nameController.text,
                                phone: phoneController.text,
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
                            ShopRegisterCubit.get(context).changeEye();
                          },
                          suffixIcon: ShopRegisterCubit.get(context).suffix,
                          obscureText: ShopRegisterCubit.get(context).isPassword,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        defaultTFF(
                          controller: phoneController,
                          prefixIcon: Icon(Icons.phone,),
                          textInputType: TextInputType.phone,
                          label: 'Phone Number',
                          validate: (String? value)
                          {
                            if(value!.isEmpty)
                            {
                              return 'please enter your Phone Number';
                            }
                          },
                          obscureText: false,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopRegisterLoadingState,
                          builder: (BuildContext context) {
                            return defaultButton(
                              text: "Register",
                              function: (){
                                if(formKey.currentState!.validate())
                                {
                                  ShopRegisterCubit.get(context).userRegister(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    name: nameController.text,
                                    phone: phoneController.text,
                                  );
                                }
                              },
                            ); },
                          fallback: (BuildContext context) => Center(child: CircularProgressIndicator()),
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
