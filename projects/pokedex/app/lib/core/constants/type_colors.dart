import 'package:flutter/material.dart';

class TypeColors {
  static const Map<String, Color> colors = {
    'normal':   Color(0xFFA8A878),
    'fire':     Color(0xFFF08030),
    'water':    Color(0xFF6890F0),
    'electric': Color(0xFFF8D030),
    'grass':    Color(0xFF78C850),
    'ice':      Color(0xFF98D8D8),
    'fighting': Color(0xFFC03028),
    'poison':   Color(0xFFA040A0),
    'ground':   Color(0xFFE0C068),
    'flying':   Color(0xFFA890F0),
    'psychic':  Color(0xFFF85888),
    'bug':      Color(0xFFA8B820),
    'rock':     Color(0xFFB8A038),
    'ghost':    Color(0xFF705898),
    'dragon':   Color(0xFF7038F8),
    'dark':     Color(0xFF705848),
    'steel':    Color(0xFFB8B8D0),
    'fairy':    Color(0xFFEE99AC),
  };

  static const Map<String, String> koreanNames = {
    'normal':   '노말',
    'fire':     '불꽃',
    'water':    '물',
    'electric': '전기',
    'grass':    '풀',
    'ice':      '얼음',
    'fighting': '격투',
    'poison':   '독',
    'ground':   '땅',
    'flying':   '비행',
    'psychic':  '에스퍼',
    'bug':      '벌레',
    'rock':     '바위',
    'ghost':    '고스트',
    'dragon':   '드래곤',
    'dark':     '악',
    'steel':    '강철',
    'fairy':    '페어리',
  };

  static Color getColor(String type) =>
      colors[type.toLowerCase()] ?? const Color(0xFFA8A878);

  static String getKoreanName(String type) =>
      koreanNames[type.toLowerCase()] ?? type;
}
