import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/models/shop_app/search_model.dart';
import 'package:news_app/network/end_points.dart';
import 'package:news_app/network/remote/dio_helper.dart';
import 'package:news_app/shared/constants.dart';
import 'package:news_app/shop_app/search/cubit/states.dart';
class SearchCubit extends Cubit<SearchStates>
{
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? model;

  void search(String text)
  {
    DioHelper.postData(
        url: PRODUCTS_SEARCH,
        token: token,
        data: {
          'text' : text,
        },
    ).then((value){
      model = SearchModel.fromJson(value?.data);
      emit(SearchSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(SearchErrorState());
    });
  }

}