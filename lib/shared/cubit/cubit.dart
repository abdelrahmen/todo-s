import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todos/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todos/modules/done_tasks/done_tasks_screen.dart';
import 'package:todos/modules/new_tasks/new_tasks_screen.dart';
import 'package:todos/shared/cubit/states.dart';

class AppCubit extends Cubit<AppState> {
  //super class always takes the initial state
  AppCubit() : super(AppInitialState());
  //a method return an object of the cubit class
  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen(),
  ];

  List<String> titleString = [
    'Active Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(ChangeBottomNavBar());
  }

  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void creatDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        print('database created');
        db
            .execute(
                'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT,date TEXT,time TEXT,status TEXT)')
            .then((value) => print('table created'))
            .catchError((e) {
          print('error ${e.toString()}');
        });
      },
      onOpen: (db) {
        getData(db);
        print('db opened');
      },
    ).then((value) {
      database = value;
      emit(CreateDatabaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    await database?.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO Tasks (title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
        print('$value inserted succesfully');
        emit(InsertDatabaseState());
        getData(database);
      }).catchError((e) {
        print('insertion error $e');
      });
      return await null;
    });
  }

  void getData(db) async {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(GetDatabaseLoadingState());
    db!.rawQuery('SELECT * FROM Tasks').then((value) {
      value.forEach(
        (element) {
          if (element['status'] == 'new') {
            newTasks.add(element);
          } else if (element['status'] == 'done') {
            doneTasks.add(element);
          } else {
            archivedTasks.add(element);
          }
        },
      );
      emit(GetDatabaseState());
    });
  }

  void updateData({
    required String status,
    required int id,
  }) async {
    await database!.rawUpdate(
        'UPDATE Tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      getData(database);
      emit(UpdateDatabaseState());
    });
  }

  void deleteData({
    required int id,
  }) async {
    await database!.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]).then((value) {
      getData(database);
      emit(DeleteFromDatabaseState());
    });
  }

  bool isBottomSheetShown = false;
  var floatingbuttonIcon = Icons.edit;

  void changeBottomSheet({
    required bool showsheet,
    required IconData icon,
  }) {
    isBottomSheetShown = showsheet;
    floatingbuttonIcon = icon;
    emit(ChangeBottomSheetState());
  }
}
