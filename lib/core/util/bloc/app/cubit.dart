import 'package:algoriza_task3/core/util/bloc/app/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppBloc extends Cubit<AppStetes> {
  AppBloc() : super(AppInitialState());

  static AppBloc get(context) => BlocProvider.of<AppBloc>(context);

  late Database database;

  void initDatabase() async {
    var databasePath = await getDatabasesPath();

    String path = join(databasePath, 'users.db');

    openAppDatabase(path: path);

    emit(AppDatabaseInitialized());
  }

  void openAppDatabase({required String path}) async {
    openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT)',
      );
    }, onOpen: (Database db) {
      database = db;
      getUsersData();
    });
  }

  TextEditingController usernameController = TextEditingController();

  void insertUserData() {
    database.transaction((txn) async {
      txn.rawInsert('INSERT INTO users(name) VALUES("${toBeginningOfSentenceCase(usernameController.text)}")');
    }).then((value) {
      usernameController.clear();

      emit(AppDatabaseUserCreated());
      getUsersData();
    });
  }

  List<Map> users = [];

  void getUsersData() async {
    emit(AppDatabaseLoading());

    database.rawQuery('SELECT * FROM users').then((value) {
      users = value;
      emit(AppDatabaseUsers());
    });
  }

  Map selectedUser = {};

  void selectUserToUpdate({required Map user}) {
    selectedUser = user;

    usernameController.text = selectedUser['name'];

    emit(AppSelectUser());
  }

  void updateUserData() async {
    database.rawUpdate('UPDATE users SET name = ? WHERE id = ${selectedUser['id']}', [
      (usernameController.text),
    ]).then((value) {
      selectedUser = {};
      usernameController.clear();

      getUsersData();
    });
  }

  void deleteUser({required Map user}) async{
    selectedUser = user;
    await database.rawDelete('DELETE FROM users WHERE name = ?', [selectedUser['name']]);
    selectedUser = {};
    emit(AppDeleteUser());
    getUsersData();
  }
}
