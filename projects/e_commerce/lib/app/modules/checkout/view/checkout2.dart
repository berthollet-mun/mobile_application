import 'package:e_commerce/app/components/space.dart';
import 'package:e_commerce/app/components/text_components.dart';
import 'package:e_commerce/app/modules/checkout/controller/controller.dart';
import 'package:e_commerce/utils/colors.dart';
import 'package:flutter/material.dart';

class Checkout2 extends StatefulWidget {
  const Checkout2({super.key});

  @override
  State<Checkout2> createState() => _Checkout2State();
}

class _Checkout2State extends State<Checkout2> {
  List<String> methodePaiement = [
    "Bank Tansfers",
    "Mobile Banking",
    "Card",
    "Payonner",
    "Amazone Hub Counter",
    "Appel Pay",
    "Googgle Pay",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextComponents(
          txt: "Chechout",
          fw: FontWeight.bold,
          txtSize: 18,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ProgressBar(setActuel: 2),
            h(20),
            TextComponents(
              txt: "Select Payement Methods",
              fw: FontWeight.bold,
              txtSize: 18,
            ),
            h(30),
            SizedBox(
              height: 400,
              child: ListView.builder(
                itemCount: methodePaiement.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: TextComponents(txt: methodePaiement[index]),
                        leading: Container(
                          height: 40,
                          width: 40,
                          color: greyColor2,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
