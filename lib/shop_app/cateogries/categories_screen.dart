import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/layout/shop_app/cubit/cubit.dart';
import 'package:news_app/layout/shop_app/cubit/states.dart';
import 'package:news_app/models/shop_app/categories_model.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);

        // Check if categoriesModel is null before building UI
        if (cubit.categoriesModel == null) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.separated(
            itemBuilder: (context, index) => buildCatItem(cubit.categoriesModel!.data!.data[index]),
            separatorBuilder: (context, index) => Divider(),
            itemCount: cubit.categoriesModel!.data!.data.length,
          );
        }
      },
    );
  }

  Widget buildCatItem(DataModel model)
  {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Image(
            image: NetworkImage(model.image!),
            width: 100.0,
            height: 100.0,
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: 8.0,
          ),
          Text(
            model.name!,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
}
