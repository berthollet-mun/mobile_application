import 'package:e_commerce/utils/colors.dart';
import 'package:flutter/material.dart';

class ButtonComponents extends StatelessWidget {
  const ButtonComponents({
    super.key,
    required this.txtButton,
    required this.buttonColor,
  });

  final String txtButton;
  final Color? buttonColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: buttonColor ?? mainColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Center(
        child: Text(
          txtButton,
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
      ),
    );
  }
}
