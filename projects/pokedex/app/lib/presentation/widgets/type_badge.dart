import 'package:flutter/material.dart';
import '../../core/constants/type_colors.dart';

class TypeBadge extends StatelessWidget {
  final String type;
  final bool small;

  const TypeBadge({super.key, required this.type, this.small = false});

  @override
  Widget build(BuildContext context) {
    final color = TypeColors.getColor(type);
    final korName = TypeColors.getKoreanName(type);

    final height = small ? 18.0 : 24.0;
    final fontSize = small ? 10.0 : 12.0;
    final hPad = small ? 6.0 : 8.0;

    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: hPad),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      alignment: Alignment.center,
      child: Text(
        korName,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          height: 1,
        ),
      ),
    );
  }
}
