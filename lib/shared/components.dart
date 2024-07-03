

//Button
import 'package:flutter/material.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:news_app/layout/shop_app/cubit/cubit.dart';
import 'package:news_app/news/webview_screen.dart';
import '../app_cubit/cubit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/shop_app/change_favorites_model.dart';

Widget defaultButton(
      {
        Color color = Colors.deepOrange,
        double width = double.infinity,
        double radius = 10.0,
        bool isUpperCase = true,
        required String text,
        required VoidCallback function,
      }) => Container(
        color: color,
        width: width,
        child: Container(
          child: MaterialButton(
            onPressed: function,
            child: Text(
              isUpperCase ? text.toUpperCase() : text,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),),
                ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
    );


//TextFormField
Widget defaultTFF({
  required TextEditingController controller,
  required TextInputType textInputType,
  required String label,
  required String? Function(String?) validate,
  Widget? prefixIcon,
  IconData? suffixIcon,
  bool obscureText = true,
  VoidCallback? suffixPressed,
  void Function(String)? onchange,
  void Function(String)? onSubmit,
  VoidCallback? onTap,
}) => TextFormField(
  controller: controller,
  keyboardType: textInputType,
  decoration: InputDecoration(
    counterStyle: TextStyle(
      color: Colors.deepOrange,
      backgroundColor:  Colors.deepOrange,
    ),
    labelText: label,
    border: OutlineInputBorder(),
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon != null ? IconButton(onPressed: suffixPressed, icon: Icon(suffixIcon,)) : null ,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey), // Border color when enabled
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.deepOrange), // Border color when focused
    ),
  ),
  validator: validate,
  obscureText: obscureText,
  onTap: onTap,
  onChanged: onchange,
  onFieldSubmitted: onSubmit,

);

Widget buildTaskItem(Map model, context)
{
  return Dismissible(
    key: Key(model['id'].toString()),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40.0,
                  child: Text(
                      '${model ['time']}'
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                  '${model ['title']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),),
                      Text(
                      '${model ['date']}',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 70.0,
                ),
                IconButton(
                  onPressed: () {
                    AppCubit.get(context).updateDataBase(
                      status: 'done',
                      id: model['id'],
                    );
                  },

                    icon: Icon(
                      Icons.check_circle,
                      color: Colors.green[400],
                    ),
                ),
                IconButton(
                  onPressed: (){
                    AppCubit.get(context).updateDataBase(status: 'archive', id: model['id'],);
                  },
                  icon: Icon(
                    Icons.archive_outlined,
                    color: Colors.black12,
                  ),
                ),
              ],
            ),
          ]
      ),
    ),
    onDismissed: (direction)
    {
      AppCubit.get(context).deleteData(id: model['id'],);
    },
  );
}

Widget conditionalItem({
  required List<Map> tasks,
})
{
  return ConditionalBuilder(
    condition: tasks.length>0,
    builder: (BuildContext context) =>ListView.separated(
      itemBuilder: (context , index) => buildTaskItem(tasks[index], context),
      separatorBuilder: (context , index) => Container(
        color: Colors.grey,
        height: 1.0,
        width: double.infinity,
      ),
      itemCount: tasks.length,
    ),
    fallback: (BuildContext context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            color: Colors.grey,
            size: 70.0,
          ),
          Text(
            'No Tasks Yet, Please Add Some Tasks',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    ),
  );
}

//news App
Widget buildArticleItems(articles, context)
{
  return InkWell(
    onTap: ()
    {
      navigateTo(context, WebViewScreen(articles['url']),);
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            width: 120.0,
            height: 120.0,
            decoration: BoxDecoration(
              borderRadius:BorderRadius.circular(10.0),
              image: DecorationImage(
                image: NetworkImage('${articles['urlToImage']}',),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Container(
              height: 120.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      '${articles['title']}',
                      maxLines: 3,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Text(
                    '${articles['publishedAt']}',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

//sperator
Widget Sperator()
{
  return Padding(
    padding: const EdgeInsets.only(left: 20.0,),
    child: Container(
      height: 1,
      width: double.infinity,
      color: Colors.grey,
    ),
  );
}

//
Widget articleBuilder(list,context,{isSearch = false}) => ConditionalBuilder(
    condition: list.length>0,
    builder: (context)
    {
      return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) => buildArticleItems(list[index], context),
        separatorBuilder: (BuildContext context, int index) => Sperator(),
      );
    },
    fallback: (context)=> isSearch ? Container() :  Center(child: CircularProgressIndicator(
      color: Colors.deepOrange,
    )));

Future<Object?> navigateTo(context, widget)
{
  return Navigator.push(
      context,
      MaterialPageRoute(
      builder: (context) => widget,
      ),
      );
}

void navigateAndFinish(context , widget)
{
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
    (route){
      return false;
      },
  );
}

Widget defaultTextButton({
  required String text,
  required VoidCallback function,
})
{
  return  TextButton(
    onPressed: function,
    child: Text(text.toUpperCase(),
      style: TextStyle(
        color: Colors.deepOrange,
      ),),
  );
}

void showToast({
  required String text,
  required ToastStates state,
}) => Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0
);


enum ToastStates {SUCCESS, ERROR, WARNING}

Color chooseToastColor(ToastStates state)
{
  Color color;

  switch(state)
  {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }

  return color;
}

Widget buildListProduct(Product model ,context) => Padding(
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



