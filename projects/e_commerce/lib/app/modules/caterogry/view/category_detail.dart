import 'package:e_commerce/app/components/text_components.dart';
import 'package:e_commerce/app/modules/productPage/controller/controller.dart';
import 'package:flutter/material.dart';

class CategoryDetail extends StatefulWidget {
  String ProductName;

  CategoryDetail({super.key, required this.ProductName});

  @override
  State<CategoryDetail> createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextComponents(
          txt: widget.ProductName,
          txtSize: 19,
          fw: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
