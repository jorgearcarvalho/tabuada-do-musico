import 'package:flutter/material.dart';

class MenuPages extends StatefulWidget {
  const MenuPages({super.key});

  @override
  State<MenuPages> createState() => _MenuPages();
}

class _MenuPages extends State<MenuPages> {
  bool _showMainMenu = true; // Tracks which menu to display

  void _toggleMenu() {
    setState(() {
      _showMainMenu = !_showMainMenu;
    });
  }

  Widget _buildMenuInicial(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _toggleMenu, // Switch to secondary menu
          child: const Text('Módulo I', style: TextStyle(fontSize: 20)),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/creditos'),
          child: const Text('Creditos', style: TextStyle(fontSize: 20)),
        )
      ],
    );
  }

  Widget _buildMenuPrincipal(BuildContext context) {
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
              const Text('Formação de acordes', style: TextStyle(fontSize: 20)),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/harmonia'),
          child:
              const Text('Funções Harmônicas', style: TextStyle(fontSize: 20)),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: _toggleMenu, // Return to main menu
          child: const Text('Retornar ao Menu Inicial',
              style: TextStyle(fontSize: 20)),
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
              : _buildMenuPrincipal(context),
        ),
      ),
    );
  }
}
