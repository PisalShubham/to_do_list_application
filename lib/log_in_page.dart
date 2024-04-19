import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';
//import 'to_do_app.dart';
import 'create_account_page.dart';
import 'home_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => SignInPageState();
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

class SignInPageState extends State<SignInPage> {
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode numberFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  final _validationKey = GlobalKey<FormState>();

  static List usersDataList = [];

  bool showPass = false;
  static String getNumber = "";

  bool isUserDataValid() {
    for (int index = 0; index < usersDataList.length; index++) {
      if (usersDataList[index].number == numberController.text &&
          usersDataList[index].password == passwordController.text) {
        return true;
      }
    }
    return false;
  }

  void userValidation() {
    if (isUserDataValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Log In Successfull!"),
          backgroundColor: Colors.green,
          showCloseIcon: true,
          shape: RoundedRectangleBorder(),
        ),
      );
      getNumber = numberController.text;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ToDoList(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("You didn't regester yet!\nPlease create an account first"),
          backgroundColor: Colors.red,
          showCloseIcon: true,
        ),
      );
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 80,
            left: 20,
            right: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 30),
                width: 300,
                height: 250,
                child: Image.asset(
                  "images/i.jpg",
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(left: 140),
                child: Text(
                  "Log In",
                  style: GoogleFonts.inter(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Form(
                key: _validationKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: numberController,
                      focusNode: numberFocusNode,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
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
                      obscureText: showPass ? false : true,
                      obscuringCharacter: "*",
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          size: 30,
                          color: Color.fromRGBO(172, 171, 171, 1),
                        ),
                        hintText: "Enter your password",
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
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please re-enter your password";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 33),
                    GestureDetector(
                      onTap: () {
                        if (_validationKey.currentState!.validate()) {
                          userValidation();
                        }
                        setState(() {});
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(40))),
                        child: Text(
                          "Sign In",
                          style: GoogleFonts.jost(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      padding: const EdgeInsets.only(left: 22),
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          Text(
                            "Don't have an account? ",
                            style: GoogleFonts.inter(
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(116, 114, 100, 1)),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CreateAccount(),
                                  ),
                                );
                              });
                            },
                            child: Text(
                              "Sign Up",
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
            ],
          ),
        ),
      ),
    );
  }
}
