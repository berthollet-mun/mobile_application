import 'package:e_commerce/app/components/button_components.dart';
import 'package:e_commerce/app/components/form_components.dart';
import 'package:e_commerce/app/components/space.dart';
import 'package:e_commerce/app/components/text_components.dart';
import 'package:e_commerce/app/modules/checkout/controller/controller.dart';
import 'package:e_commerce/app/modules/checkout/view/checkout2.dart';
import 'package:e_commerce/utils/colors.dart';
import 'package:flutter/material.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  List<String> cities = ['city 1', 'city 2', 'city 3', 'city4'];
  List<String> districts = [
    'District 1',
    'District 2',
    'District 3',
    'Districts 4',
  ];
  String selectedCity = "";
  String selectedDisticts = "";

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProgressBar(setActuel: 1),
            h(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextComponents(
                  txt: "Shipping Adsress",
                  fw: FontWeight.bold,
                  txtSize: 18,
                ),
              ],
            ),
            h(20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextComponents(txt: "Name", fw: FontWeight.bold),
                h(10),
                FormComponents(),
                h(20),
                TextComponents(txt: "Town/city", fw: FontWeight.bold),
                h(10),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButton(
                    isExpanded: true,
                    value: selectedCity.isEmpty ? null : selectedCity,
                    hint: TextComponents(
                      txt: "cliquer ici pour séléctionner",
                      fw: FontWeight.bold,
                      color: Colors.grey,
                    ),

                    items: cities.map<DropdownMenuItem<String>>((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCity = value!;
                      });
                    },
                  ),
                ),
                h(20),
                TextComponents(txt: "Postal Code", fw: FontWeight.bold),
                h(10),
                FormComponents(),
                h(20),
                TextComponents(txt: "District", fw: FontWeight.bold),
                h(10),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButton(
                    isExpanded: true,
                    value: selectedDisticts.isEmpty ? null : selectedDisticts,
                    hint: TextComponents(
                      txt: "cliquer ici pour séléctionner",
                      fw: FontWeight.bold,
                      color: Colors.grey,
                    ),

                    items: districts.map<DropdownMenuItem<String>>((
                      String item,
                    ) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDisticts = value!;
                      });
                    },
                  ),
                ),
                h(20),
                TextComponents(txt: "Phone", fw: FontWeight.bold),
                h(10),
                FormComponents(),
                h(20),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Checkout2()),
                    );
                  },
                  child: ButtonComponents(
                    txtButton: "Next",
                    buttonColor: mainColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
