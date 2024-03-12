import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'loginpage.dart';
import 'main.dart';
import 'package:sqflite/sqflite.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoAppState();
}

// Model class for the application which is used to
// store the data enter by the user in appropriate format.
class ToDoModelClass {
  int? taskNo;
  String title;
  String description;
  String date;
  bool checkedValue = false;

  ToDoModelClass({
    this.taskNo,
    required this.title,
    required this.description,
    required this.date,
  });

  // defining a function return a map of data for the database
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
    };
  }

  @override
  String toString() {
    return "{taskNo: $taskNo, title: $title, description: $description, date: $date}";
  }
}

// function to insert the data in database

Future<void> insertData(ToDoModelClass obj) async {
  final localDB = await database;

  localDB.insert(
    "AppData",
    obj.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// function to retrive the data from the database

Future<List<ToDoModelClass>> getData() async {
  final localDB = await database;

  List<Map<String, dynamic>> result = await localDB.query("AppData");

  return List.generate(result.length, (index) {
    return ToDoModelClass(
      taskNo: result[index]['taskNo'],
      title: result[index]['title'],
      description: result[index]['description'],
      date: result[index]['date'],
    );
  });
}

// function to delete the data from database

Future<void> deleteTask(int taskData) async {
  final localDB = await database;

  await localDB.delete(
    "AppData",
    where: "taskNo = ?",
    whereArgs: [taskData],
  );
}

// function to update the data from database

Future<void> updateCardData(ToDoModelClass obj) async {
  final localDB = await database;

  await localDB.update("AppData", obj.toMap(),
      where: 'taskNo=?', whereArgs: [obj.taskNo]);
}

class _ToDoAppState extends State<ToDoList> {
  final TextEditingController titleEditingController = TextEditingController();
  final TextEditingController descriptionEditingController =
      TextEditingController();
  final TextEditingController dateEditingController = TextEditingController();

  // list used by ListView for rendering the data
  List cardsList = [];

  final _validationKey = GlobalKey<FormState>();

  // When user clicked on submit this function checks that the data
  // entered by the user is valid or not if yes then it submit the data
  // and if not then it return the error message.

  void isCardValid(bool onEdit, [index]) async {
    if (titleEditingController.text.trim().isEmpty ||
        descriptionEditingController.text.trim().isEmpty ||
        dateEditingController.text.trim().isEmpty) {
      // check the validity of textfields
      // by calling the validator() function
      if (_validationKey.currentState!.validate()) {}
    } else {
      if (onEdit) {
        // if user wants to edit the existing card
        cardsList[index].title = titleEditingController.text;
        cardsList[index].description = descriptionEditingController.text;
        cardsList[index].date = dateEditingController.text;
        updateCardData(cardsList[index]);
      } else {
        // if user want to add a new card to the list
        await insertData(
          ToDoModelClass(
            title: titleEditingController.text,
            description: descriptionEditingController.text,
            date: dateEditingController.text,
          ),
        );
        cardsList = await getData();
      }

      Navigator.of(context).pop();
    }
  }

  // When user clicked on add button to add a new card or
  // clicked on edit button when user wants to edit the existing card
  // this function will be called.

  Future<void> bottomSheet(bool doEdit, [int? index]) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                "Create Tasks",
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Form(
                key: _validationKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Title",
                      style: GoogleFonts.quicksand(
                        color: const Color.fromRGBO(89, 57, 241, 1),
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),

                    // title TextField
                    TextFormField(
                      controller: titleEditingController,
                      decoration: InputDecoration(
                        hintText: "Enter Title",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(89, 57, 241, 1),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter valid title";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Description",
                      style: GoogleFonts.quicksand(
                        color: const Color.fromRGBO(89, 57, 241, 1),
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    // description TextField
                    TextFormField(
                      controller: descriptionEditingController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Enter Description",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(89, 57, 241, 1),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter description";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Date",
                      style: GoogleFonts.quicksand(
                        color: const Color.fromRGBO(89, 57, 241, 1),
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                    // date TextField
                    const SizedBox(
                      height: 3,
                    ),
                    TextFormField(
                      controller: dateEditingController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: "Enter Date",
                        suffixIcon: const Icon(Icons.date_range_rounded),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(89, 57, 241, 1),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2023),
                          lastDate: DateTime(2025),
                        );
                        String formatedDate =
                            DateFormat.yMMMd().format(pickedDate!);
                        dateEditingController.text = formatedDate;
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please select date";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Submit button
              Container(
                height: 50,
                width: 300,
                margin: const EdgeInsets.all(10),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30)),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        13,
                      ),
                    ),
                    backgroundColor: const Color.fromRGBO(89, 57, 241, 1),
                  ),
                  onPressed: () {
                    isCardValid(doEdit, index);
                    setState(() {});
                  },
                  child: Text(
                    "Submit",
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // this function is used to render a data everytime user login
  // because this function always called before the build function called
  // in widgets lifecycle.
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    cardsList = await getData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(111, 81, 255, 1),
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 35,
              margin: const EdgeInsets.only(left: 365),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Logout Successful"),
                        backgroundColor: Colors.grey,
                        showCloseIcon: true,
                      ),
                    );
                  });
                },
                icon: const Icon(
                  Icons.logout_rounded,
                  size: 35,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 33, top: 15),
              child: Text(
                "Good Morning",
                style: GoogleFonts.quicksand(
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 32),
              child: Text(
                LoginState().username,
                // "Core2web",
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 33,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(217, 217, 217, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    Text(
                      "CREATE TASKS",
                      style: GoogleFonts.quicksand(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(
                          right: 5,
                          left: 5,
                          top: 18,
                        ),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: ListView.builder(
                          itemCount: cardsList.length,
                          itemBuilder: (context, index) {
                            return Slidable(
                              closeOnScroll: true,
                              endActionPane: ActionPane(
                                extentRatio: 0.2,
                                motion: const DrawerMotion(),
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const SizedBox(height: 11),
                                        GestureDetector(
                                          onTap: () {
                                            bottomSheet(true, index);
                                            titleEditingController.text =
                                                cardsList[index].title;
                                            descriptionEditingController.text =
                                                cardsList[index].description;
                                            dateEditingController.text =
                                                cardsList[index].date;
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            height: 40,
                                            width: 40,
                                            decoration: const BoxDecoration(
                                              color: Color.fromRGBO(
                                                  89, 57, 241, 1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.edit_outlined,
                                              color: Colors.white,
                                              size: 22,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            deleteTask(cardsList[index].taskNo);
                                            cardsList.removeAt(index);
                                            setState(() {});
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            height: 40,
                                            width: 40,
                                            decoration: const BoxDecoration(
                                              color: Color.fromRGBO(
                                                  89, 57, 241, 1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.delete_outline,
                                              color: Colors.white,
                                              size: 22,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              child: Container(
                                margin: const EdgeInsets.only(top: 10),
                                padding: const EdgeInsets.only(
                                  left: 12,
                                  bottom: 20,
                                  top: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(255, 255, 255, 1),
                                  border: Border.all(
                                    color: const Color.fromRGBO(0, 0, 0, 0.5),
                                    width: 0.5,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      offset: Offset(0, 4),
                                      blurRadius: 20,
                                      color: Color.fromRGBO(0, 0, 0, 0.13),
                                    ),
                                  ],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 60,
                                          width: 60,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color.fromRGBO(
                                                217, 217, 217, 1),
                                          ),
                                          child: Image.asset(
                                            "images/Group.png",
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        SizedBox(
                                          width: 260,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                cardsList[index].title,
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                cardsList[index].description,
                                                style: GoogleFonts.inter(
                                                    color: const Color.fromRGBO(
                                                        0, 0, 0, 0.7),
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                cardsList[index].date,
                                                style: GoogleFonts.inter(
                                                  color: const Color.fromRGBO(
                                                      0, 0, 0, 0.7),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Checkbox(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          activeColor: Colors.green,
                                          value: cardsList[index].checkedValue,
                                          onChanged: (value) {
                                            setState(() {
                                              cardsList[index].checkedValue =
                                                  !cardsList[index]
                                                      .checkedValue;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(89, 57, 241, 1),
        onPressed: () async {
          titleEditingController.clear();
          descriptionEditingController.clear();
          dateEditingController.clear();
          await bottomSheet(false);
          setState(() {});
        },
        child: const Icon(
          Icons.add,
          size: 50,
          color: Colors.white,
        ),
      ),
    );
  }
}
