import 'package:e_commerce/app/components/button_components.dart';
import 'package:e_commerce/app/components/space.dart';
import 'package:e_commerce/app/components/text_components.dart';
import 'package:e_commerce/utils/colors.dart';
import 'package:flutter/material.dart';

class Filter extends StatefulWidget {
  const Filter({super.key});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  bool all = true;
  bool nike = false;
  bool bata = false;
  bool adidas = false;

  bool allGender = true;
  bool menGender = false;
  bool kidsGender = false;

  bool allSize = true;
  bool size1 = false;
  bool size2 = false;

  final List<String> categories = [
    "T-shirt",
    "Jeans",
    "Shoes",
    "Panjabi",
    "Watches",
  ];

  String selectedValue = "";

  double valeurActuelle = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: TextComponents(txt: "Filter", fw: FontWeight.bold, txtSize: 19),
        actions: [Icon(Icons.delete), w(15)],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextComponents(txt: "Brands", fw: FontWeight.bold, txtSize: 18),
            h(10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        all = true;
                        nike = bata = adidas = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      height: 40,
                      decoration: BoxDecoration(
                        color: all ? mainColor : Colors.white,
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: TextComponents(
                          txt: "All",
                          fw: FontWeight.bold,
                          color: all ? Colors.white : Colors.black87,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  w(10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        nike = true;
                        all = bata = adidas = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      height: 40,
                      decoration: BoxDecoration(
                        color: nike ? mainColor : Colors.white,
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: TextComponents(
                          txt: "Nike",
                          fw: FontWeight.bold,
                          color: nike ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  w(10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        bata = true;
                        all = nike = adidas = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      height: 40,
                      decoration: BoxDecoration(
                        color: bata ? mainColor : Colors.white,
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: TextComponents(
                          txt: "Bata",
                          fw: FontWeight.bold,
                          color: bata ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  w(10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        adidas = true;
                        all = nike = bata = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      height: 40,
                      decoration: BoxDecoration(
                        color: adidas ? mainColor : Colors.white,
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: TextComponents(
                          txt: "Adidas",
                          fw: FontWeight.bold,
                          color: adidas ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            h(10),

            TextComponents(txt: "Gender", fw: FontWeight.bold, txtSize: 18),
            h(10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        allGender = true;
                        menGender = kidsGender = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      height: 40,
                      decoration: BoxDecoration(
                        color: allGender ? mainColor : Colors.white,
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: TextComponents(
                          txt: "All",
                          fw: FontWeight.bold,
                          color: allGender ? Colors.white : Colors.black87,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  w(10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        menGender = true;
                        allGender = kidsGender = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      height: 40,
                      decoration: BoxDecoration(
                        color: menGender ? mainColor : Colors.white,
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: TextComponents(
                          txt: "Men",
                          fw: FontWeight.bold,
                          color: menGender ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  w(10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        kidsGender = true;
                        allGender = menGender = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      height: 40,
                      decoration: BoxDecoration(
                        color: kidsGender ? mainColor : Colors.white,
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: TextComponents(
                          txt: "Kids",
                          fw: FontWeight.bold,
                          color: kidsGender ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            h(10),
            TextComponents(
              txt: "Select Product",
              fw: FontWeight.bold,
              txtSize: 18,
            ),
            h(10),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black38),
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButton(
                isExpanded: true,
                value: selectedValue.isEmpty ? null : selectedValue,
                hint: Text(
                  "Cliquez ici pour choisir le produit",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                items: categories.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedValue = value!;
                  });
                },
              ),
            ),
            h(10),
            TextComponents(
              txt: "Select Size",
              fw: FontWeight.bold,
              txtSize: 18,
            ),
            h(10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        allSize = true;
                        size1 = size2 = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      height: 40,
                      decoration: BoxDecoration(
                        color: allSize ? mainColor : Colors.white,
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: TextComponents(
                          txt: "All",
                          fw: FontWeight.bold,
                          color: allSize ? Colors.white : Colors.black87,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  w(10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        size1 = true;
                        allSize = size2 = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      height: 40,
                      decoration: BoxDecoration(
                        color: size1 ? mainColor : Colors.white,
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: TextComponents(
                          txt: "5 In",
                          fw: FontWeight.bold,
                          color: size1 ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  w(10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        size2 = true;
                        allSize = size1 = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      height: 40,
                      decoration: BoxDecoration(
                        color: size2 ? mainColor : Colors.white,
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: TextComponents(
                          txt: "10 In",
                          fw: FontWeight.bold,
                          color: size2 ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            h(10),
            TextComponents(txt: "Price", fw: FontWeight.bold, txtSize: 18),

            Slider(
              min: 0,
              max: 100,
              divisions: 2,
              label: valeurActuelle.round().toString(),

              value: valeurActuelle,
              onChanged: (value) {
                setState(() {
                  valeurActuelle = value;
                });
              },
            ),

            TextComponents(
              txt: "Select Color",
              fw: FontWeight.bold,
              txtSize: 18,
            ),
            h(10),

            Row(
              children: [
                CircleAvatar(backgroundColor: Colors.brown, radius: 15),
                w(10),

                CircleAvatar(backgroundColor: Colors.grey, radius: 15),
                w(10),

                CircleAvatar(backgroundColor: Colors.blue, radius: 15),
                w(10),

                CircleAvatar(backgroundColor: Colors.green, radius: 15),
                w(10),

                CircleAvatar(backgroundColor: Colors.orange, radius: 15),
                w(10),

                CircleAvatar(backgroundColor: Colors.red, radius: 15),
              ],
            ),
            h(20),
            InkWell(
              onTap: () {},
              child: ButtonComponents(
                txtButton: "Filter Now",
                buttonColor: mainColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
