import 'package:e_commerce/app/components/button_components.dart';
import 'package:e_commerce/app/components/form_components.dart';
import 'package:e_commerce/app/components/space.dart';
import 'package:e_commerce/app/components/text_components.dart';
import 'package:e_commerce/app/modules/connexion/view/login.dart';
import 'package:e_commerce/app/modules/opt/view/opt.dart';
import 'package:e_commerce/utils/colors.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              TextComponents(
                txt: "Forgot Password",
                fw: FontWeight.bold,
                txtSize: 25,
              ),
              h(10),
              TextComponents(
                txt:
                    "Don't worry ! It Occurs. Please enter the enail adress linked with your account",
                textAlign: TextAlign.center,
              ),
              h(10),
              Image.asset('assets/images/forgot.png', scale: 1.7),
              h(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextComponents(txt: "Email/Phone", fw: FontWeight.bold),
                ],
              ),
              FormComponents(textInputType: TextInputType.emailAddress),
              h(20),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OTP()),
                  );
                },
                child: ButtonComponents(
                  txtButton: "Send",
                  buttonColor: mainColor,
                ),
              ),
              h(20),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                child: TextComponents(txt: "Back to login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
