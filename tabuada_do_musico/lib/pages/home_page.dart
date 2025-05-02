import 'package:flutter/material.dart';
import 'package:tcc_app/pages/menu/menu_pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Tabuada do Músico',
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.library_music_rounded,
                  size: 40.0,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.only(left: 50, right: 50),
              child: Text(
                  'Um aplicativo para auxiliar no seu estudo de teoria musical',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.justify),
            ),
            const SizedBox(height: 20),
            Image.asset('assets/images/clave_de_sol.webp',
                width: 150, height: 150),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuPages()),
                );
              },
              child: const Text(
                'Jogar',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
