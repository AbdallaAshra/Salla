
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/app_cubit/states.dart';

import 'package:sqflite/sqflite.dart';


class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialStates());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<String> title = [
    'Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  void changeIndex(int index)
  {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  late Database database;
  void createDataBase()
  {
    openDatabase(
      'todo.db',
      version:1,
      onCreate:(database, version)
      {
        print('DB created');
        database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)').then((value){
          print('table created');
        }).catchError((error){
          print('error while creating table ${error.toString()}');});
      },
      onOpen: (database)
      {
        getDataFromDatabase(database);
      },
    ).then((value) {
      database = value;
      emit(AppCreateDataBaseState());
    });
  }


  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) async {
      txn.rawInsert(
        'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")',
      )
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDataBaseState());

        getDataFromDatabase(database);
      }).catchError((error) {
        print('Error When Inserting New Record ${error.toString()}');
      });

    });
  }



  void getDataFromDatabase(database)
  {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];

    emit(AppGetDataBaseLoadingState());

    database.rawQuery('SELECT * FROM tasks').then((value) {

      value.forEach((element)
      {
        if(element['status'] == 'new')
          newTasks.add(element);
        else if(element['status'] == 'done')
          doneTasks.add(element);
        else archiveTasks.add(element);
      });

      emit(AppGetDataBaseState());
    });
  }

  void updateDataBase({
    required String status,
    required int id,
  }) async
  {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value)
    {
      getDataFromDatabase(database);
      emit(AppUpdateDataBaseState());
    });
  }

  void deleteData({
    required int id,
  }) async
  {
    database.rawDelete( 'DELETE FROM tasks WHERE id = ?', [id]).then((value)
    {
      getDataFromDatabase(database);
      emit(AppDeleteDataBaseState());
    });
  }



  bool isBottomSheetActivate = false;
  IconData fabICON = Icons.add;
  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
})
  {
    isBottomSheetActivate = isShow;
    fabICON = icon;
    emit(AppChangBottomSheetState());
  }


  bool isDark = false;
  void changeMode({bool? fromShared,}) async
  {
    if(fromShared != null)
    {
      isDark = fromShared;
      emit(NewsChangeModeStates());
    }
    else {
      isDark = !isDark;
        emit(NewsChangeModeStates());
      };
    }
  }

