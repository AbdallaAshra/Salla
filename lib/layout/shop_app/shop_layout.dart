import 'package:flutter/material.dart';
import 'package:news_app/layout/shop_app/cubit/cubit.dart';
import 'package:news_app/layout/shop_app/cubit/states.dart';
import 'package:news_app/network/local/cache_helper.dart';
import 'package:news_app/shared/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/shop_app/login_screen/login_screen.dart';
import 'package:news_app/shop_app/search/search_screen.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, state) {
        var cubit = ShopCubit.get(context);
        return Scaffold(
        appBar: AppBar(
          title: Text(
            'Salla',
            style: TextStyle(
              fontSize: 30.0,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search,),
              onPressed: (){
                navigateTo(context, SearchScreen());
              },
            ),
          ],
        ),
        body: cubit.bottomScreens[cubit.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index)
          {
            cubit.changeBottom(index);
          },
          currentIndex: cubit.currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home,),
              label: 'Home',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.apps,),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite,),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings,),
              label: 'Settings',
            ),
          ],
        ),
      );}
    );
  }
}
