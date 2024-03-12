import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'loginpage.dart';

dynamic database;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  database = openDatabase(
    join(await getDatabasesPath(), "AppDB.db"),
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''CREATE TABLE AppData(
          taskNo INTEGER PRIMARY KEY,
          title TEXT,
          description TEXT,
          date TEXT)''');
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
