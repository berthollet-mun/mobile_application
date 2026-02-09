import 'package:e_commerce/app/components/button_components.dart';
import 'package:e_commerce/app/components/space.dart';
import 'package:e_commerce/app/components/text_components.dart';
import 'package:e_commerce/app/modules/productPage/view/product_page.dart';
import 'package:e_commerce/utils/colors.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            TextComponents(
              txt: "Lets get started with shopping!",
              fw: FontWeight.bold,
              txtSize: 28,
              textAlign: TextAlign.center,
            ),
            h(20),
            TextComponents(
              txt: "Find it here, by it now !",
              txtSize: 19,
              textAlign: TextAlign.center,
            ),
            h(40),
            Image.asset("assets/images/welcom.png"),
            h(40),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProductPage()),
                );
              },
              child: ButtonComponents(
                txtButton: "Get Started",
                buttonColor: mainColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
