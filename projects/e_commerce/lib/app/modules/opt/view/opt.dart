import 'package:e_commerce/app/components/button_components.dart';
import 'package:e_commerce/app/components/space.dart';
import 'package:e_commerce/app/components/text_components.dart';
import 'package:e_commerce/app/modules/changePassword/view/change_password.dart';
import 'package:e_commerce/utils/colors.dart';
import 'package:flutter/material.dart';

class OTP extends StatefulWidget {
  const OTP({super.key});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            TextComponents(
              txt: "Verification Code",
              txtSize: 25,
              fw: FontWeight.bold,
            ),
            h(15),
            TextComponents(
              txt:
                  "Please enter the 4 digit code sent to \nkenzi.lawson@example.com",
              txtSize: 20,
              textAlign: TextAlign.center,
            ),
            h(30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  height: 60,
                  width: 60,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      counterText: '',
                    ),
                    maxLength: 1,
                    onChanged: (value) {
                      if (value.length == 1 && index < 5) {
                        FocusScope.of(context).nextFocus();
                      } else if (value.isEmpty && index > 0) {
                        FocusScope.of(context).previousFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            h(20),
            TextComponents(txt: "Code expire in : 02:30", txtSize: 17),
            h(20),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePassword()),
                );
              },
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: ButtonComponents(
                  txtButton: "Verify",
                  buttonColor: mainColor,
                ),
              ),
            ),
            h(20),
            TextComponents(txt: "Dit not receive OTP?  Resend"),
          ],
        ),
      ),
    );
  }
}
