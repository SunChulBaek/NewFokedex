import 'package:flutter/material.dart';
import '../../core/constants/type_colors.dart';

class TypeBadge extends StatelessWidget {
  final String type;

  const TypeBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final color = TypeColors.getColor(type);
    final korName = TypeColors.getKoreanName(type);

    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12), // pill shape
      ),
      alignment: Alignment.center,
      child: Text(
        korName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 1,
        ),
      ),
    );
  }
}
