import 'package:e_commerce/app/components/button_components.dart';
import 'package:e_commerce/app/components/space.dart';
import 'package:e_commerce/app/components/text_components.dart';
import 'package:e_commerce/app/modules/caterogry/view/category_detail.dart';
import 'package:e_commerce/utils/colors.dart';
import 'package:flutter/material.dart';

bool isMan = true;
bool isKids = false;

CategorieBox(String ProductName, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CategoryDetail(ProductName: ProductName),
        ),
      );
    },
    child: Container(
      padding: EdgeInsets.only(right: 20),
      child: Column(
        children: [
          CircleAvatar(radius: 30, backgroundColor: greyColor),
          h(10),
          TextComponents(txt: ProductName, fw: FontWeight.bold),
        ],
      ),
    ),
  );
}

ProductBox(
  String ProductName,
  ProductReview,
  ProductPriceNormal,
  ProductPricePromo,
) {
  return Card(
    color: Colors.white,
    child: SizedBox(
      height: 350,
      child: Column(
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: greyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),
          h(20),
          TextComponents(txt: ProductName, fw: FontWeight.bold, txtSize: 18),
          h(10),
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.deepOrange, size: 20),
                    Icon(Icons.star, color: Colors.deepOrange, size: 20),
                    Icon(Icons.star, color: Colors.deepOrange, size: 20),
                    Icon(Icons.star, color: Colors.deepOrange, size: 20),
                    Icon(Icons.star, color: Color(0xFFF2C1A6), size: 20),
                  ],
                ),
                TextComponents(
                  txt: ProductReview,
                  txtSize: 15,
                  fw: FontWeight.bold,
                ),
              ],
            ),
          ),
          h(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextComponents(
                txt: ProductPriceNormal,
                fw: FontWeight.bold,
                txtSize: 17,
              ),
              w(10),
              Text(
                ProductPricePromo,
                style: TextStyle(
                  fontFamily: "Regular",
                  fontSize: 16,
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          h(10),
          Container(
            height: 35,
            margin: EdgeInsets.only(left: 15, right: 15),
            child: ButtonComponents(
              txtButton: "Add to Card",
              buttonColor: mainColor,
            ),
          ),
        ],
      ),
    ),
  );
}
