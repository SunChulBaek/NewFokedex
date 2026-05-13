import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_detail.freezed.dart';
part 'pokemon_detail.g.dart';

@freezed
class PokemonDetail with _$PokemonDetail {
  const factory PokemonDetail({
    required int id,
    required String name,
    @JsonKey(name: 'base_experience') required int baseExperience,
    required int height,
    required int weight,
    required List<PokemonType> types,
    required List<PokemonStat> stats,
    required List<PokemonAbility> abilities,
    required PokemonSprites sprites,
  }) = _PokemonDetail;

  factory PokemonDetail.fromJson(Map<String, dynamic> json) =>
      _$PokemonDetailFromJson(json);

  const PokemonDetail._();

  String get primaryType => types.isNotEmpty ? types.first.type.name : 'normal';

  String get officialArtworkUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
}

@freezed
class PokemonType with _$PokemonType {
  const factory PokemonType({
    required int slot,
    required TypeInfo type,
  }) = _PokemonType;

  factory PokemonType.fromJson(Map<String, dynamic> json) =>
      _$PokemonTypeFromJson(json);
}

@freezed
class TypeInfo with _$TypeInfo {
  const factory TypeInfo({
    required String name,
    required String url,
  }) = _TypeInfo;

  factory TypeInfo.fromJson(Map<String, dynamic> json) =>
      _$TypeInfoFromJson(json);
}

@freezed
class PokemonStat with _$PokemonStat {
  const factory PokemonStat({
    @JsonKey(name: 'base_stat') required int baseStat,
    required int effort,
    required StatInfo stat,
  }) = _PokemonStat;

  factory PokemonStat.fromJson(Map<String, dynamic> json) =>
      _$PokemonStatFromJson(json);
}

@freezed
class StatInfo with _$StatInfo {
  const factory StatInfo({
    required String name,
    required String url,
  }) = _StatInfo;

  factory StatInfo.fromJson(Map<String, dynamic> json) =>
      _$StatInfoFromJson(json);
}

@freezed
class PokemonAbility with _$PokemonAbility {
  const factory PokemonAbility({
    @JsonKey(name: 'is_hidden') required bool isHidden,
    required int slot,
    required AbilityInfo ability,
  }) = _PokemonAbility;

  factory PokemonAbility.fromJson(Map<String, dynamic> json) =>
      _$PokemonAbilityFromJson(json);
}

@freezed
class AbilityInfo with _$AbilityInfo {
  const factory AbilityInfo({
    required String name,
    required String url,
  }) = _AbilityInfo;

  factory AbilityInfo.fromJson(Map<String, dynamic> json) =>
      _$AbilityInfoFromJson(json);
}

@freezed
class PokemonSprites with _$PokemonSprites {
  const factory PokemonSprites({
    @JsonKey(name: 'front_default') String? frontDefault,
    @JsonKey(name: 'front_shiny') String? frontShiny,
  }) = _PokemonSprites;

  factory PokemonSprites.fromJson(Map<String, dynamic> json) =>
      _$PokemonSpritesFromJson(json);
}

/// 사람이 읽기 쉬운 스탯 이름 변환
String statDisplayName(String statName) {
  const map = {
    'hp': 'HP',
    'attack': '공격',
    'defense': '방어',
    'special-attack': '특공',
    'special-defense': '특방',
    'speed': '스피드',
  };
  return map[statName] ?? statName;
}
