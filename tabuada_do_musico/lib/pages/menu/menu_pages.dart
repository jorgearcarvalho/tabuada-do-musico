import 'package:flutter/material.dart';

class MenuPages extends StatefulWidget {
  const MenuPages({super.key});

  @override
  State<MenuPages> createState() => _MenuPages();
}

class _MenuPages extends State<MenuPages> {
  bool _showMainMenu = true; // Tracks which menu to display
  int modulo = 0;

  void _ativaModulo1() {
    setState(() {
      _showMainMenu = !_showMainMenu;
      modulo = 1;
    });
  }

  void _ativaModulo2() {
    setState(() {
      _showMainMenu = !_showMainMenu;
      modulo = 2;
    });
  }

  Widget _buildMenuInicial(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _ativaModulo1, // Switch to secondary menu
          child: const Text('Módulo I - Formação básica',
              style: TextStyle(fontSize: 20)),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/creditos'),
          child: const Text('Creditos', style: TextStyle(fontSize: 20)),
        )
      ],
    );
  }

  Widget _buildMenuPrincipalModulo1(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/intervalos'),
          child: const Text('Intervalos', style: TextStyle(fontSize: 20)),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/acordes'),
          child:
              const Text('Formação de Acordes', style: TextStyle(fontSize: 20)),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/escalas'),
          child:
              const Text('Formação de Escalas', style: TextStyle(fontSize: 20)),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/harmonia'),
          child: const Text('Campo Harmônico', style: TextStyle(fontSize: 20)),
        ),
        const SizedBox(height: 60),
        ElevatedButton(
          onPressed: _ativaModulo1, // Return to main menu
          child: const Text('menu inicial', style: TextStyle(fontSize: 20)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabuada do Músico'),
      ),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _showMainMenu
              ? _buildMenuInicial(context)
              : _buildMenuPrincipalModulo1(context),
        ),
      ),
    );
  }
}
