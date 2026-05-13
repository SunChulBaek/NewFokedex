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
}
