import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/layout/shop_app/cubit/cubit.dart';
import 'package:news_app/layout/shop_app/cubit/states.dart';
import 'package:news_app/shared/components.dart';
import 'package:news_app/shop_app/search/cubit/cubit.dart';
import 'package:news_app/shop_app/search/cubit/states.dart';

class SearchScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (BuildContext context, ShopStates state) {  },
        builder: (BuildContext context, ShopStates state)
        {
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    defaultTFF(
                      obscureText: false,
                        controller: searchController,
                        textInputType: TextInputType.text,
                        label: 'Search',
                        validate: (String? value)
                        {
                          if(value!.isEmpty)
                          {
                            return 'enter text to search';
                          }else{return null;}
                        },
                      onSubmit: (String text)
                      {
                        SearchCubit.get(context).search(text);
                      }
                    ),
                    SizedBox(height: 10.0,),
                    if(state is SearchLoadingState)
                      LinearProgressIndicator(),
                    SizedBox(height: 10.0,),
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) => buildFavItem(SearchCubit.get(context).model!.data!.data![index],context),
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: SearchCubit.get(context).model!.data!.data!.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  Widget buildFavItem(model ,context) => Padding(
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
