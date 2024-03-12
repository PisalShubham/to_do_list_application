import 'package:flutter/Material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'to_do_app.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State createState() => LoginState();
}

class LoginState extends State {
  TextEditingController userNameEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  FocusNode userNameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  final _logInKey = GlobalKey<FormState>();

  final String username = "ShubhamPisal";
  final String password = "S@123";

  bool showPass = false;

  void userValidation(bool isValidate) {
    if (isValidate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login Successful"),
          backgroundColor: Colors.green,
          showCloseIcon: true,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login Failed!\nWrong Username or Password"),
          backgroundColor: Colors.red,
          showCloseIcon: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "To-do list",
          style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromRGBO(116, 114, 100, 1),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(height: 100),
              SizedBox(
                //height: 300,
                width: 300,
                //color: Colors.amber,
                child: Image.asset(
                  "images/i.jpg",
                  //fit: BoxFit.cover,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                ),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(116, 114, 100, 0.4),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      offset: Offset(10, 10),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: Form(
                  key: _logInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Username",
                        style: GoogleFonts.quicksand(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: userNameEditingController,
                        focusNode: userNameFocusNode,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Invalid Username";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "Password",
                        style: GoogleFonts.quicksand(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: passwordEditingController,
                        focusNode: passwordFocusNode,
                        obscureText: showPass ? false : true,
                        obscuringCharacter: "*",
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
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
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.visibility_outlined,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Invalid Password";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 30),
                      Container(
                        margin: const EdgeInsets.only(left: 90),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_logInKey.currentState!.validate()) {
                              if (userNameEditingController.text == username &&
                                  passwordEditingController.text == password) {
                                userValidation(true);
                                userNameEditingController.clear();
                                passwordEditingController.clear();
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ToDoList()));
                                });
                              } else {
                                userValidation(false);
                              }
                            }
                          },
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                              Color.fromRGBO(238, 237, 235, 1),
                            ),
                          ),
                          child: Text(
                            "Log In",
                            style: GoogleFonts.quicksand(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 160),
            ],
          ),
        ),
      ),
    );
  }
}
