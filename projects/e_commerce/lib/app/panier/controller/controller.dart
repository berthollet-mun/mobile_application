import 'package:e_commerce/app/components/space.dart';
import 'package:e_commerce/app/components/text_components.dart';
import 'package:e_commerce/utils/colors.dart';
import 'package:flutter/material.dart';

CustomProductBox(String productName, description, price) {
  return Column(
    children: [
      h(15),
      Row(
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: Color(0xFFefefef),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.shopping_bag, color: Colors.grey, size: 40),
          ),
          w(20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextComponents(
                      txt: productName,
                      fw: FontWeight.bold,
                      txtSize: 18,
                    ),
                    Icon(Icons.highlight_remove, color: Colors.grey),
                  ],
                ),
                TextComponents(
                  txt: description,
                  color: Colors.grey,
                  fw: FontWeight.bold,
                ),
                h(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextComponents(txt: price, fw: FontWeight.bold),
                    Row(
                      children: [
                        InkWell(
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              color: homeBg,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(child: Icon(Icons.remove, size: 15)),
                          ),
                        ),
                        w(10),
                        TextComponents(txt: "01"),
                        w(10),
                        InkWell(
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              color: homeBg,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(child: Icon(Icons.add, size: 15)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      h(15),
      Divider(),
    ],
  );
}
