import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/shop_app/cubit/cubit.dart';
import '../../layout/shop_app/cubit/states.dart';
import 'package:news_app/models/shop_app/favorites_model.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);

        // Check if favoritesModel is null before building UI
        if (cubit.favoritesModel == null) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ConditionalBuilder(
            condition: state is! ShopLoadingGetFavoritesState,
            builder: (BuildContext context) {
              return ListView.separated(
              itemBuilder: (context, index) => buildFavItem(ShopCubit.get(context).favoritesModel!.data!.data![index].product!,context),
              separatorBuilder: (context, index) => Divider(),
              itemCount: ShopCubit.get(context).favoritesModel!.data!.data!.length,
            ); },
            fallback: (BuildContext context) => Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget buildFavItem(Product model ,context) => Padding(
    padding: const EdgeInsets.all(20.0),
    child: Container(
      height: 120.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                image: NetworkImage(model.image!),
                width: 120.0,
                height: 120.0,
                fit: BoxFit.cover,
              ),
              if (model.discount != 0)
                Container(
                  color: Colors.red,
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.0,
                  ),
                  child: Text(
                    'DISCOUNT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8.0,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(
            width:  20.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    height: 1.3,
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    Text(
                      model.price.toString(),
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.deepOrange,
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    if (model.discount != 0)
                      Text(
                        model.oldPrice.toString(),
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        ShopCubit.get(context).changeFavorites(model.id!);
                      },
                      icon: CircleAvatar(
                        radius: 15.0,
                        backgroundColor: ShopCubit.get(context).favorites[model.id]! ? Colors.deepOrange : Colors.grey,
                        child: Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

}
