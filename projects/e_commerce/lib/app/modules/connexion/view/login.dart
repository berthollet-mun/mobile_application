import 'package:e_commerce/app/components/button_components.dart';
import 'package:e_commerce/app/components/form_components.dart';
import 'package:e_commerce/app/components/space.dart';
import 'package:e_commerce/app/components/text_components.dart';
import 'package:e_commerce/app/modules/motDepasseOublier/view/forgot_password.dart';
import 'package:e_commerce/utils/colors.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: TextComponents(
                  txt: 'Sign In Now',
                  fw: FontWeight.bold,
                  txtSize: 25,
                ),
              ),
              h(40),
              TextComponents(txt: "Email/Phone", txtSize: 17),
              h(10),
              FormComponents(),

              h(20),
              TextComponents(txt: "Password", txtSize: 17),
              h(10),
              FormComponents(
                hide: true,
                textInputType: TextInputType.visiblePassword,
              ),
              h(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextComponents(txt: "Remeber me", color: Colors.black38),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPassword(),
                        ),
                      );
                    },
                    child: TextComponents(
                      txt: "Forgot password",
                      color: mainColor,
                      fw: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              h(20),
              ButtonComponents(txtButton: "Login", buttonColor: mainColor),
              h(80),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(height: 1, width: 120, color: Colors.black38),
                  TextComponents(txt: "Or Continue with"),
                  Container(height: 1, width: 120, color: Colors.black38),
                ],
              ),

              h(20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(color: mainColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(child: TextComponents(txt: "Google")),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(color: mainColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(child: TextComponents(txt: "Google")),
                    ),
                  ),
                ],
              ),
              h(40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextComponents(
                    txt: "Dont' have any account?",
                    fw: FontWeight.bold,
                  ),
                  SizedBox(width: 10),
                  TextComponents(
                    txt: "Sign up",
                    fw: FontWeight.bold,
                    color: mainColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
