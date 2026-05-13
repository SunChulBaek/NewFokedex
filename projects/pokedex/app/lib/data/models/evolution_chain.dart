/// 진화 체인 파싱 모델 (Freezed 없이 순수 Dart)
class EvolutionNode {
  final int id;
  final String name;
  final String? koreanName;
  final String? evolutionTrigger; // 진화 조건 텍스트
  final List<EvolutionNode> evolvesTo;

  const EvolutionNode({
    required this.id,
    required this.name,
    this.koreanName,
    this.evolutionTrigger,
    this.evolvesTo = const [],
  });

  String get displayName => koreanName ?? _capitalize(name);

  String get spriteUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  /// JSON chain 파싱: { species, evolution_details, evolves_to }
  static EvolutionNode fromChainJson(Map<String, dynamic> chain) {
    final speciesUrl = chain['species']['url'] as String;
    final id = _extractId(speciesUrl);
    final name = chain['species']['name'] as String;

    final evolvesTo = (chain['evolves_to'] as List)
        .map((e) => EvolutionNode.fromChainJsonWithDetails(
              e as Map<String, dynamic>,
            ))
        .toList();

    return EvolutionNode(
      id: id,
      name: name,
      evolvesTo: evolvesTo,
    );
  }

  static EvolutionNode fromChainJsonWithDetails(
      Map<String, dynamic> chain) {
    final speciesUrl = chain['species']['url'] as String;
    final id = _extractId(speciesUrl);
    final name = chain['species']['name'] as String;

    // 진화 조건 파싱
    String? trigger;
    final details = chain['evolution_details'] as List;
    if (details.isNotEmpty) {
      final detail = details.first as Map<String, dynamic>;
      trigger = _parseTrigger(detail);
    }

    final evolvesTo = (chain['evolves_to'] as List)
        .map((e) => EvolutionNode.fromChainJsonWithDetails(
              e as Map<String, dynamic>,
            ))
        .toList();

    return EvolutionNode(
      id: id,
      name: name,
      evolutionTrigger: trigger,
      evolvesTo: evolvesTo,
    );
  }

  static int _extractId(String url) {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    return int.tryParse(segments.last) ?? 0;
  }

  static String? _parseTrigger(Map<String, dynamic> detail) {
    final trigger = detail['trigger']?['name'] as String?;
    if (trigger == 'level-up') {
      final level = detail['min_level'];
      if (level != null) return 'Lv.$level';
      final happiness = detail['min_happiness'];
      if (happiness != null) return '친밀도';
      return '레벨업';
    } else if (trigger == 'use-item') {
      final item = detail['item']?['name'] as String?;
      return item != null ? _itemKorean(item) : '아이템';
    } else if (trigger == 'trade') {
      return '통신교환';
    }
    return trigger;
  }

  static String _itemKorean(String item) {
    const map = {
      'fire-stone': '불꽃의돌',
      'water-stone': '물의돌',
      'thunder-stone': '천둥의돌',
      'leaf-stone': '리프의돌',
      'moon-stone': '달의돌',
      'sun-stone': '태양의돌',
      'shiny-stone': '빛의돌',
      'dusk-stone': '어둠의돌',
      'dawn-stone': '새벽의돌',
      'ice-stone': '얼음의돌',
    };
    return map[item] ?? item;
  }

  /// 트리를 평탄화하여 선형 진화 경로로 변환 (단순 3단계용)
  List<List<EvolutionNode>> toChains() {
    if (evolvesTo.isEmpty) return [[this]];
    final chains = <List<EvolutionNode>>[];
    for (final next in evolvesTo) {
      for (final subChain in next.toChains()) {
        chains.add([this, ...subChain]);
      }
    }
    return chains;
  }
}
