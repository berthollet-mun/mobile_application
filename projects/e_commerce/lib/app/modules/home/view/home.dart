import 'package:e_commerce/app/components/button_components.dart';
import 'package:e_commerce/app/components/space.dart';
import 'package:e_commerce/app/components/text_components.dart';
import 'package:e_commerce/app/modules/connexion/view/login.dart';
import 'package:e_commerce/app/modules/inscription/view/inscription.dart';
import 'package:e_commerce/utils/colors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: homeBg),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          color: homeBg,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,

          child: Column(
            children: [
              TextComponents(txt: "Welcome", txtSize: 35, fw: FontWeight.bold),
              TextComponents(txt: "ManMode Shoping House", txtSize: 18),
              h(40),
              Image.asset('assets/images/home.png', scale: 1.1),

              h(40),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Inscription()),
                  );
                },
                child: ButtonComponents(
                  txtButton: 'sing up',
                  buttonColor: mainColor,
                ),
              ),
              h(20),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                child: ButtonComponents(
                  txtButton: 'Login',
                  buttonColor: Colors.grey,
                ),
              ),
              h(20),
              TextComponents(txt: 'Not thanks'),
            ],
          ),
        ),
      ),
    );
  }
}
