import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite/sqflite.dart';
import 'main.dart';
import 'log_in_page.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class UserModelClass {
  int? userID;
  final String name;
  final String number;
  final String password;

  UserModelClass({
    this.userID,
    required this.name,
    required this.number,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'number': number,
      'password': password,
    };
  }

  @override
  String toString() {
    return '{userID: $userID, name: $name, number: $number, password: $password}';
  }
}

Future<void> insertData(UserModelClass obj) async {
  final localDB = await database;

  localDB.insert(
    "UserInformation",
    obj.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<UserModelClass>> getData() async {
  final localDB = await database;

  List<Map<String, dynamic>> dataList = await localDB.query("UserInformation");

  return List.generate(dataList.length, (index) {
    return UserModelClass(
      userID: dataList[index]['userID'],
      name: dataList[index]['name'],
      number: dataList[index]['number'],
      password: dataList[index]['password'],
    );
  });
}

class _CreateAccountState extends State<CreateAccount> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode numberFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();

  final _validationKey = GlobalKey<FormState>();

  List usersDataList = [];

  bool showPass = false;
  bool isChecked = false;

  bool isNewUserValid(String number) {
    for (int i = 0; i < usersDataList.length; i++) {
      if (usersDataList[i].number == number) {
        return false;
      } else {}
    }

    return true;
  }

  void onSignUp() async {
    if (nameController.text.trim().isEmpty ||
        numberController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty ||
        !isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please accept the terms of services!"),
          backgroundColor: Colors.red,
          showCloseIcon: true,
        ),
      );
      if (_validationKey.currentState!.validate()) {}
    } else {
      if (!isNewUserValid(numberController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("You already have an account!"),
            backgroundColor: Colors.red,
            showCloseIcon: true,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User Regestration Successful"),
            backgroundColor: Colors.green,
            showCloseIcon: true,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SignInPage(),
          ),
        );
        await insertData(UserModelClass(
          name: nameController.text,
          number: numberController.text,
          password: passwordController.text,
        ));
        usersDataList = await getData();
        nameController.clear();
        numberController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        isChecked = false;
      }
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    usersDataList = await getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign Up",
          style: GoogleFonts.inter(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            setState(() {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignInPage(),
                ),
              );
            });
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 30,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 40,
            left: 20,
            right: 20,
          ),
          child: Form(
            key: _validationKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  focusNode: nameFocusNode,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.person_2_outlined,
                      size: 30,
                      color: Color.fromRGBO(172, 171, 171, 1),
                    ),
                    hintText: "Enter Your Name",
                    hintStyle: GoogleFonts.inter(
                      color: const Color.fromRGBO(172, 171, 171, 1),
                      fontSize: 20,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(172, 171, 171, 1),
                        width: 2,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your name";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: numberController,
                  focusNode: numberFocusNode,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    counterText: '',
                    prefixIcon: const Icon(
                      Icons.phone_rounded,
                      size: 30,
                      color: Color.fromRGBO(172, 171, 171, 1),
                    ),
                    hintText: "Enter Your Mobile Number",
                    hintStyle: GoogleFonts.inter(
                      color: const Color.fromRGBO(172, 171, 171, 1),
                      fontSize: 20,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(172, 171, 171, 1),
                        width: 2,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your number";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: passwordController,
                  focusNode: passwordFocusNode,
                  obscureText: true,
                  obscuringCharacter: "*",
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock_open_sharp,
                      size: 30,
                      color: Color.fromRGBO(172, 171, 171, 1),
                    ),
                    hintText: "Create your password",
                    hintStyle: GoogleFonts.inter(
                      color: const Color.fromRGBO(172, 171, 171, 1),
                      fontSize: 20,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(172, 171, 171, 1),
                        width: 2,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter password";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: confirmPasswordController,
                  focusNode: confirmPasswordFocusNode,
                  obscureText: showPass ? false : true,
                  obscuringCharacter: "*",
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      size: 30,
                      color: Color.fromRGBO(172, 171, 171, 1),
                    ),
                    hintText: "Confirm your password",
                    hintStyle: GoogleFonts.inter(
                      color: const Color.fromRGBO(172, 171, 171, 1),
                      fontSize: 20,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(172, 171, 171, 1),
                        width: 2,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          showPass = !showPass;
                        });
                      },
                      icon: showPass
                          ? const Icon(
                              Icons.visibility_off_outlined,
                              color: Color.fromRGBO(172, 171, 171, 1),
                            )
                          : const Icon(
                              Icons.visibility_outlined,
                              color: Color.fromRGBO(172, 171, 171, 1),
                            ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        value.trim() != passwordController.text) {
                      return "Please re-enter your password";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      activeColor: Colors.green,
                      value: isChecked,
                      onChanged: (val) {
                        setState(() {
                          isChecked = !isChecked;
                        });
                      },
                    ),
                    const SizedBox(width: 5),
                    SizedBox(
                      child: Row(
                        children: [
                          Text(
                            "I agree to the ",
                            style: GoogleFonts.inter(
                              fontSize: 19,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            "Terms of Services",
                            style: GoogleFonts.inter(
                                fontSize: 19,
                                fontWeight: FontWeight.w400,
                                color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () async {
                    if (passwordController.text !=
                        confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Your password dosen't match\nplease enter valid password",
                          ),
                          backgroundColor: Colors.red,
                          showCloseIcon: true,
                        ),
                      );
                    } else {
                      onSignUp();
                      setState(() {});
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 130,
                      top: 15,
                      bottom: 5,
                    ),
                    width: 340,
                    height: 60,
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(89, 57, 241, 1),
                        borderRadius: BorderRadius.all(Radius.circular(40))),
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.jost(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(left: 22),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Text(
                        "already have an account ? ",
                        style: GoogleFonts.inter(
                            fontSize: 19,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(172, 171, 171, 1)),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignInPage(),
                              ),
                            );
                          });
                        },
                        child: Text(
                          "Log In",
                          style: GoogleFonts.inter(
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromRGBO(89, 57, 241, 1)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
