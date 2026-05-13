import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 수치 구간별 색상 반환 (견희 디자인 명세)
Color statBarColor(int value) {
  if (value < 45) return const Color(0xFFFF5959);
  if (value < 90) return const Color(0xFFFFAD33);
  if (value < 135) return const Color(0xFF9DB920);
  return const Color(0xFF2DB52D);
}

class StatBar extends StatefulWidget {
  final String label;
  final int value;
  final int maxValue;
  final int animationDelay; // ms

  const StatBar({
    super.key,
    required this.label,
    required this.value,
    this.maxValue = 255,
    this.animationDelay = 0,
  });

  @override
  State<StatBar> createState() => _StatBarState();
}

class _StatBarState extends State<StatBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    Future.delayed(Duration(milliseconds: widget.animationDelay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = statBarColor(widget.value);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: Text(
              widget.label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ),
          SizedBox(
            width: 32,
            child: Text(
              widget.value.toString(),
              textAlign: TextAlign.end,
              style: GoogleFonts.rajdhani(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1C1B1F),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, _) => LinearProgressIndicator(
                  value: _animation.value * (widget.value / widget.maxValue),
                  backgroundColor: const Color(0xFFF5F5F5),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
