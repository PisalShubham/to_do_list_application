import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'log_in_page.dart';

dynamic database;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  database = openDatabase(
    join(await getDatabasesPath(), "db2.db"),
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''CREATE TABLE AppData(
          userNum TEXT,
          taskNo INTEGER PRIMARY KEY,
          title TEXT,
          description TEXT,
          date TEXT)''');

      await db.execute('''CREATE TABLE UserInformation(
        userID INTEGER PRIMARY KEY,
        name TEXT,
        number TEXT,
        password TEXT
      )''');
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SignInPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
