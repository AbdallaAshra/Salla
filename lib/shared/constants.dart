import 'package:news_app/shared/components.dart';

import '../network/local/cache_helper.dart';
import '../shop_app/login_screen/login_screen.dart';

void signOut (context)
{
  CacheHelper.removeData(key: 'token').then((value){
    if(value!)
    {
      navigateAndFinish(context, ShopLoginScreen());
    }
  });
}

void printFullText(String text)
{
  final pattern =RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

String? token = '';