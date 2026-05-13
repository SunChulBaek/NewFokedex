import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 선택된 세대 필터 (null = 전체)
final selectedGenerationProvider = StateProvider<int?>((ref) => null);
