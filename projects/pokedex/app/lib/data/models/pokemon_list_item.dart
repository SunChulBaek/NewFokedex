import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_list_item.freezed.dart';
part 'pokemon_list_item.g.dart';

@freezed
class PokemonListItem with _$PokemonListItem {
  const factory PokemonListItem({
    required String name,
    required String url,
  }) = _PokemonListItem;

  factory PokemonListItem.fromJson(Map<String, dynamic> json) =>
      _$PokemonListItemFromJson(json);

  const PokemonListItem._();

  /// URL에서 포켓몬 ID 추출: .../pokemon/25/ → 25
  int get id {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    return int.tryParse(segments.last) ?? 0;
  }

  String get spriteUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
}
