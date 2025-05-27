import 'package:flutter/material.dart';

class BonequinhoTematico extends StatelessWidget {
  final String imagePath;
  final double height;
  final double borderRadius;
  final BoxFit fit;

  const BonequinhoTematico({
    super.key,
    required this.imagePath,
    this.height = 180,
    this.borderRadius = 16,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.asset(
          imagePath,
          height: height,
          fit: fit,
        ),
      ),
    );
  }
}
