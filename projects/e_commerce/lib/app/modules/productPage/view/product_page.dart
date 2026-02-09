import 'package:e_commerce/app/components/space.dart';
import 'package:e_commerce/app/components/text_components.dart';
import 'package:e_commerce/app/modules/filter/view/filter.dart';
import 'package:e_commerce/app/modules/productPage/controller/controller.dart';
import 'package:e_commerce/app/panier/view/panier.dart';
import 'package:e_commerce/utils/colors.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        toolbarHeight: 30,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  height: 60,
                  width: MediaQuery.of(context).size.width / 1.4,
                  decoration: BoxDecoration(
                    color: greyColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search, size: 30),
                      hintText: "Search your product",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontFamily: "Bold",
                        fontWeight: FontWeight.bold,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Pannier()),
                    );
                  },
                  child: CircleAvatar(
                    backgroundColor: greyColor,
                    radius: 30,
                    child: Center(
                      child: Icon(Icons.shopping_bag_outlined, size: 30),
                    ),
                  ),
                ),
              ],
            ),
            h(40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isMan = true;
                          isKids = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        height: 40,
                        decoration: BoxDecoration(
                          color: isMan ? mainColor : Colors.white,
                          border: Border.all(color: mainColor),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: TextComponents(
                            txt: "Man",
                            fw: FontWeight.bold,
                            color: isMan ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isMan = false;
                          isKids = true;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        height: 40,
                        decoration: BoxDecoration(
                          color: isKids ? mainColor : Colors.white,
                          border: Border.all(color: mainColor),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: TextComponents(
                            txt: "Kids",
                            fw: FontWeight.bold,
                            color: isKids ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Filter()),
                    );
                  },
                  child: Icon(Icons.menu, size: 35),
                ),
              ],
            ),
            h(30),
            Container(
              height: 180,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: greyColor2,
                borderRadius: BorderRadius.circular(20),
                // image: DecorationImage(
                //   image: AssetImage("assets/images/logo.png"),
                // ),
              ),
            ),
            h(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextComponents(
                  txt: "categories",
                  fw: FontWeight.bold,
                  txtSize: 17,
                ),
                TextComponents(
                  txt: "See all ",
                  fw: FontWeight.bold,
                  color: mainColor,
                  txtSize: 17,
                ),
              ],
            ),
            h(20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CategorieBox("T-Shirt", context),
                  CategorieBox("Jeans", context),
                  CategorieBox("Shoes", context),
                  CategorieBox("Panjama", context),
                  CategorieBox("Whatch", context),
                  CategorieBox("Whatch", context),
                  CategorieBox("Whatch", context),
                  CategorieBox("Whatch", context),
                  CategorieBox("Whatch", context),
                ],
              ),
            ),
            h(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextComponents(txt: "All Product", fw: FontWeight.bold),
              ],
            ),
            h(20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: (MediaQuery.of(context).size.width / 2) - 20,
                  child: ProductBox(
                    "Panjabi",
                    "13 Reviews",
                    "Tk 1500",
                    "TKP1900",
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
