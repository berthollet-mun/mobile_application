import 'package:e_commerce/app/components/text_components.dart';
import 'package:e_commerce/app/modules/home/view/home.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    // On attend que la première frame soit affichée
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //Attente de 5 secondes
      await Future.delayed(const Duration(seconds: 5));

      // Vérifie que le widget est toujours monté (sinon erreur)
      if (context.mounted) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          height: 240,
          width: 200,
          child: Column(
            children: [
              Image.asset('assets/images/logo.png', scale: 1.2),
              TextComponents(txt: 'ManMode', txtSize: 30, fw: FontWeight.bold),
              TextComponents(txt: 'Fashion House', txtSize: 20),
            ],
          ),
        ),
      ),
    );
  }
}
