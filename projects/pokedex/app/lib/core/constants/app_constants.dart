class AppConstants {
  // PokeAPI
  static const String baseUrl = 'https://pokeapi.co/api/v2';
  static const String spriteBaseUrl =
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork';

  // 페이지네이션
  static const int pageSize = 20;

  // 포켓몬 타입 목록 (18종)
  static const List<String> pokemonTypes = [
    'normal', 'fire', 'water', 'electric', 'grass', 'ice',
    'fighting', 'poison', 'ground', 'flying', 'psychic', 'bug',
    'rock', 'ghost', 'dragon', 'dark', 'steel', 'fairy',
  ];

  /// 세대별 포켓몬 ID 범위 (PokeAPI 기준)
  static const Map<int, ({int start, int end})> generationRanges = {
    1: (start: 1,   end: 151),
    2: (start: 152, end: 251),
    3: (start: 252, end: 386),
    4: (start: 387, end: 493),
    5: (start: 494, end: 649),
    6: (start: 650, end: 721),
    7: (start: 722, end: 809),
    8: (start: 810, end: 905),
    9: (start: 906, end: 1025),
  };

  static const List<String> generationLabels = [
    '1세대', '2세대', '3세대', '4세대', '5세대',
    '6세대', '7세대', '8세대', '9세대',
  ];
}
