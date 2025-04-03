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
                  size: 50.0,
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
                'Um aplicativo para \nauxiliar no seu estudo \nde teorial musical',
                style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Image.asset('images/clave_de_sol.webp', width: 150, height: 150),
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
